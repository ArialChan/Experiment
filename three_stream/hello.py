# # import tensorflow as tf
# # print(tf.__version__)
#
# import sys
# import numpy  as np
# import os, gc
# import pickle
# import copy
# import logging
# import threading
# from queue import Queue
# import collections
# import torch
# import random
# import itertools
#
# video_root_dir = "/home/chc/Downloads/LUNA_VIDEO/visual_features2/"
# video_list = []
# for file in os.listdir(video_root_dir):
#     if file.endswith(".npy"):  # 끝이 ".npy"로 끝나는 경우
#         video_list.append(os.path.splitext(file)[0])
#
# random.seed(100)
# random.shuffle(video_list)
#
# with open('video_shuffle.pkl', "wb") as file:
#     pickle.dump(video_list, file)
#     print(video_list)
#
#
# with open('video_shuffle.pkl', 'rb') as file:
#     gts = pickle.load(file)
#     print(gts)

import numpy as np
import os
import pickle as pkl
import re

npy_path = "./exp/data/MSR-VTT/test/audio_features/"
npy_path2 = "/home/chc/PycharmProjects/VGGish/models/research/audioset/result2/"
npy_path3 = "/home/chc/models/research/audioset/result/"
npy_path4 = "/home/chc/models/research/audioset/test/"



data1 = np.load(npy_path+"video7018.npy")
data2 = np.load(npy_path2+"video7014.npy")
data3 = np.load(npy_path3+"video7014.npy")
# data4 = np.load(npy_path4+"video7011.npy")



print(np.shape(data1))
print(np.shape(data2))
print(np.shape(data3))
# print(np.shape(data4))

data_v = np.load("/home/chc/PycharmProjects/chc_env/HACAModel_dev/exp/data/MSR-VTT/train/video_features/video6.npy")
print(np.shape(data_v))

# print(data1[1])
# print(data2[1])
# print(data3[1])