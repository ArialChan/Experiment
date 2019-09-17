import pickle
import numpy as np



video_list_file = "./meta_data/train_vid_ids.pkl"
# video_list_file = "./meta_data/test_vid_ids.pkl"

caption_file = "./meta_data/train_vid_to_caption.pkl"
caption_file2 = "./meta_data/test_vid_to_caption.pkl"

vocab_file = "./meta_data/vocab.pkl"

with open(video_list_file, "rb") as file:
    video_list = pickle.load(file)
    print("video list len : ", len(video_list))
    max_videos = len(video_list)

for video in video_list:
    # print(video)
    if video == 'video7944':
       print("same")
print(video_list[:10])

with open(caption_file,"rb") as file:
    caption_list = pickle.load(file)
    print("caption list len : ", len(caption_list))
print(caption_list)

with open(caption_file2,"rb") as file:
    caption_list2 = pickle.load(file)
    print("caption list2 len : ", len(caption_list2))
# print(caption_list2)
# print("shape : ", np.shape(np.array(caption_list)))

caption_list.update(caption_list2)
print("append caption list len : ",len(caption_list))


with open('./meta_data/cider_jsons/gts_test.pkl', 'rb') as file:
    gts = pickle.load(file)
    # print(gts)
print(len(gts['annotations']))
print(gts.keys())

# with open(vocab_file,"rb") as file:
#     vocab_list = pickle.load(file)
#     print(vocab_list)
#
#
# if max_videos != -1:
#     video_list = video_list[:max_videos]
# print(video_list)
#
# input_files = []
# for i in range(7010):
#     input_files.append('video{}'.format(i))
# print(input_files)
# for video_number in video_list:
    # print("ddddd : ", video_number)