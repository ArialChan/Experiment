import sys
import numpy  as np
import os, gc
import pickle
import copy
import logging
import threading
from queue import Queue
import collections
import torch
import re
import random
import json
import itertools
from video_category_check import *

logger = logging.getLogger(__name__)

vocab_path = "./meta_data/vocab.pkl"
vocab = pickle.load(open(vocab_path,'rb'))
id_to_word = {v: k for k, v in vocab.items()}



video_input_size = 2048 # 원래 2048
audio_input_size = 128
max_len = {"video" : 60, "audio" : 20}

END = vocab['<END>']
PAD = vocab['<PAD>']

def process(caption,max_length):
    caption_x  = caption[:-1]
    caption_y = caption[1:]
    if len(caption_x) > max_length:
        caption_x = caption[:max_length]
        caption_y = caption[1:max_length]
        caption_y.append(END)
    return (caption_x,caption_y)

def convert_to_batch(features, modality="video"):
    batch = np.zeros((len(features), max_len[modality], features[0][0].shape[0]))
    for counter in range(len(features)):
        batch[counter,:min(max_len[modality],len(features[counter])),:] = features[counter][:max_len[modality]]
    return batch

class SSFetcher(threading.Thread):
    def __init__(self, parent):
        threading.Thread.__init__(self)
        self.parent = parent
        self.video_files = self.parent.video_list
        self.indices = list(range(len(self.video_files)))
        self.caption_inds = list(range(min(20,parent.captions_per_vid)))
        self.indices = list(itertools.product(self.indices,self.caption_inds))
        assert len(self.indices) == parent.num_data_points
        np.random.shuffle(self.indices)

    def run(self):
        diter = self.parent
        offset = 0
        i = 0
        while not diter.exit_flag:
            last_batch = False
            counter = 0
            vid_features = []
            aud_features = []
            pwc_features = []
            caption_x_batch = PAD*np.ones((diter.batch_size, diter.max_caption_length))
            caption_y_batch = PAD*np.ones((diter.batch_size, diter.max_caption_length))
            mask = np.zeros((diter.batch_size, diter.max_caption_length))
            video_ids = []
            while counter < diter.batch_size:
                if offset == diter.num_data_points:
                    last_batch = True
                    diter.queue.put(None)
                    return
                index = self.indices[offset]
                video_file = self.video_files[index[0]]
                caption = diter.vid_to_caption_map[video_file][index[1]]
                video_features = np.load(os.path.join(diter.video_root_dir, video_file+".npy"))
                audio_features = np.load(os.path.join(diter.audio_root_dir, video_file+".npy"))
                optic_features = np.load(os.path.join(diter.pwc_root_dir, video_file+".npy"))
                caption_x,caption_y = process(caption,diter.max_caption_length)
                vid_features.append(video_features)
                aud_features.append(audio_features)
                pwc_features.append(optic_features)
                caption_x_batch[counter, :len(caption_x)] = caption_x
                caption_y_batch[counter, :len(caption_x)] = caption_y
                mask[counter, :len(caption_x)] = 1
                video_ids.append(video_file)
                counter += 1
                offset += 1

            if counter == diter.batch_size:
                vid_batch = convert_to_batch(vid_features, modality="video")
                aud_batch = convert_to_batch(aud_features, modality="audio")
                pwc_batch = convert_to_batch(pwc_features, modality="video")
                batch = {}
                batch["audio_features"] = torch.from_numpy(aud_batch).type(torch.float32)
                batch["visual_features"] = torch.from_numpy(vid_batch).type(torch.float32)
                batch["pwc_features"] = torch.from_numpy(pwc_batch).type(torch.float32)
                batch["caption_x"] = torch.from_numpy(caption_x_batch).type(torch.long)
                batch["caption_y"] = torch.from_numpy(caption_y_batch).type(torch.long)
                batch["mask"] = torch.from_numpy(mask).type(torch.float32)
                batch["video_ids"] = video_ids
                if diter.device.type == "cuda":
                    for key in batch:
                        if type(batch[key]) != list:
                            batch[key] = batch[key].cuda()
                diter.queue.put(batch)
                i+=1

            if last_batch:
                diter.queue.put(None)
                return

class SSIterator(object):
    def __init__(self,
                 batch_size,
                 max_caption_length,
                 captions_per_vid,
                 mode,
                 device,
                 max_videos=-1):

        self.batch_size = batch_size
        self.max_caption_length = max_caption_length
        self.exit_flag = False
        self.use_infinite_loop = False
        self.mode = mode
        self.device = device
        self.captions_per_vid = captions_per_vid
        self.max_videos = max_videos
        self.load_files()


    def load_files(self):
        caption_file = "./meta_data/{}_vid_to_caption.pkl".format(self.mode)
        video_list_file = "./meta_data/{}_vid_ids.pkl".format(self.mode)


        ###
        caption_file1 = "./meta_data/train_vid_to_caption.pkl"
        caption_file2 = "./meta_data/valid_vid_to_caption.pkl"
        caption_file3 = "./meta_data/test_vid_to_caption.pkl"
        caption_file4 = "./meta_data/luna_vid_to_caption.pkl"


        # if self.mode == "test":
        #     self.video_root_dir = "./exp/data/MSR-VTT/test/video_features/"
        #     self.audio_root_dir = "./exp/data/MSR-VTT/test/audio_features/"
        #     self.pwc_root_dir = "./exp/data/MSR-VTT/test/pwc_features/"
        # elif self.mode == "cat_test":
        #     self.video_root_dir = "./exp/data/MSR-VTT/cat_test/video_features/"
        #     self.audio_root_dir = "./exp/data/MSR-VTT/cat_test/audio_features/"
        #     self.pwc_root_dir = "./exp/data/MSR-VTT/cat_test/pwc_features/"
        # else:
        #     self.video_root_dir = "./exp/data/MSR-VTT/train/video_features/"  #/home/chc/PycharmProjects/chc_env/HACAModel/exp/data/MSR-VTT/train/video_features
        #     self.audio_root_dir = "./exp/data/MSR-VTT/train/audio_features/"
        #     self.pwc_root_dir = "./exp/data/MSR-VTT/train/pwc_features/"
        ###


        # luna vidoe training path
        self.video_root_dir = "/home/chc/Downloads/LUNA_VIDEO/visual_features2/"
        self.audio_root_dir = "/home/chc/Downloads/LUNA_VIDEO/audio_features/"
        self.pwc_root_dir = "/home/chc/Downloads/LUNA_VIDEO/pwc_features2/"


        # with open(caption_file, "rb") as file:
        #     self.vid_to_caption_map = pickle.load(file)
        #
        # with open(video_list_file, "rb") as file:
        #     self.video_list = pickle.load(file)


        ### add
        self.vid_to_caption_map = dict()
        with open(caption_file1, "rb") as file:
            self.vid_to_caption_map1 = pickle.load(file)
            self.vid_to_caption_map.update(self.vid_to_caption_map1)
        with open(caption_file2, "rb") as file:
            self.vid_to_caption_map2 = pickle.load(file)
            self.vid_to_caption_map.update(self.vid_to_caption_map2)
        with open(caption_file3, "rb") as file:
            self.vid_to_caption_map3 = pickle.load(file)
            self.vid_to_caption_map.update(self.vid_to_caption_map3)
        with open(caption_file4, "rb") as file: # luna captioning 정보 추가
            self.vid_to_caption_map4 = pickle.load(file)
            self.vid_to_caption_map.update(self.vid_to_caption_map4)
        # print("{}_vid_to_caption len : ".format(self.mode), len(self.vid_to_caption_map))

        # self.video_list = []
        # if self.mode == "test":
        #     for i in range(7010, 10000):
        #         self.video_list.append('video{}'.format(i))
        # elif self.mode == "valid":
        #     for i in range(6513, 7010):
        #         self.video_list.append('video{}'.format(i))
        # else:
        #     for i in range(6513):
        #         self.video_list.append('video{}'.format(i))
        # ##

        # self.video_list = []
        # if self.mode == "test":
        #     with open('./exp/data/MSR-VTT/test_videodatainfo.json', 'rb') as file:
        #         data = json.load(file)
        #     for item in range(len(data['videos'])):
        #         i = int(re.findall('\d+', data['videos'][item]['video_id'] )[0])
        #         if data['videos'][item]['category'] == 3:
        #             self.video_list.append(data['videos'][item]['video_id'])
        #     print('video list len : ', len(self.video_list))
        # elif self.mode == "valid":
        #     with open('./exp/data/MSR-VTT/train_val_videodatainfo.json', 'rb') as file:
        #         data = json.load(file)
        #     for item in range(len(data['videos'])):
        #         i = int(re.findall('\d+', data['videos'][item]['video_id'])[0])
        #         if data['videos'][item]['category'] == 3 and i >= 6513:
        #             self.video_list.append(data['videos'][item]['video_id'])
        #     print('video list len : ', len(self.video_list))
        # else:
        #     with open('./exp/data/MSR-VTT/train_val_videodatainfo.json', 'rb') as file:
        #         data = json.load(file)
        #     for item in range(len(data['videos'])):
        #         i = int(re.findall('\d+', data['videos'][item]['video_id'])[0])
        #         if data['videos'][item]['category'] == 3 and i < 6513:
        #             self.video_list.append(data['videos'][item]['video_id'])
        #     print('video list len : ',len(self.video_list))

        self.video_list = []
        for file in os.listdir(self.video_root_dir):
            if file.endswith(".npy"):  # 끝이 ".npy"로 끝나는 경우
                self.video_list.append(os.path.splitext(file)[0])
        # for i in range(500, 577):
        #     self.video_list.append('clip{}'.format(i))
        random.seed(100)
        random.shuffle(self.video_list)
        print('video list len : ',len(self.video_list))

        if self.mode == "test":
            self.video_list = self.video_list[350:]
            print("test : ",self.video_list)
        elif self.mode == "valid":
            self.video_list = self.video_list[325:350]
            print("valid : ",self.video_list)
        else:
            self.video_list = self.video_list[0:325]
            print("train : ",self.video_list)


        if self.max_videos != -1:
            self.video_list = self.video_list[:self.max_videos]
        self.num_data_points = len(self.video_list)*min(self.captions_per_vid, 20)
        # print("video_list : ", self.video_list)

    def start(self):
        self.exit_flag = False
        self.queue = Queue(maxsize = 5)
        self.gather = SSFetcher(self)
        self.gather.daemon = True
        self.gather.start()

    def __del__(self):
        if hasattr(self, 'gather'):
            self.gather.exitFlag = True
            self.gather.join()

    def __iter__(self):
        return self

    def next(self):
        if self.exit_flag:
            return None

        batch = self.queue.get()
        if not batch:
            self.exit_flag = True
        return batch
