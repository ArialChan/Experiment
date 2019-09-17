import numpy as np
import os
import pickle as pkl
import re

npy_path = "./exp/data/MSR-VTT/test/audio_features/"
npy_path2 = "/home/chc/PycharmProjects/VGGish/models/research/audioset/result2/"
npy_path3 = "/home/chc/models/research/audioset/result/"
npy_path4 = "/home/chc/models/research/audioset/test/"

data1 = np.load(npy_path+"video7018.npy")
data2 = np.load(npy_path2+"video7018.npy")
data3 = np.load(npy_path3+"video7018.npy")
# data4 = np.load(npy_path4+"video7011.npy")



print(np.shape(data1))
print(np.shape(data2))
print(np.shape(data3))
# print(np.shape(data4))


print(data1[1])
print(data2[1])
print(data3[1])
# print(data4[1])
# print(data1[15])

#
# test_data_path = "/home/chc/Downloads/MSR_VTT/test_videos/TestAudio_nonSilence/"
#
# train_data_path = "/home/chc/Downloads/MSR_VTT/train_val_videos/TrainValAudio_nonSilence/"
#
# test_video_list = []
# train_video_list = []
# valid_video_list = []
#
# for file in os.listdir(test_data_path):
#     if file.endswith(".wav"):  # 끝이 ".npy"로 끝나는 경우
#         test_video_list.append(os.path.splitext(file)[0])
#
#
# for file in os.listdir(train_data_path):
#     i = int(re.findall('\d+', os.path.splitext(file)[0])[0])
#     if file.endswith(".wav") and i >= 6513:  # 끝이 ".npy"로 끝나는 경우
#         valid_video_list.append(os.path.splitext(file)[0])
#
# for file in os.listdir(train_data_path):
#     i = int(re.findall('\d+', os.path.splitext(file)[0])[0])
#     if file.endswith(".wav") and i < 6513:  # 끝이 ".npy"로 끝나는 경우
#         train_video_list.append(os.path.splitext(file)[0])
#
# with open('test.pkl', 'wb') as f:
#     pkl.dump(test_video_list, f)
# with open('valid.pkl', 'wb') as f:
#     pkl.dump(valid_video_list, f)
# with open('train.pkl', 'wb') as f:
#     pkl.dump(train_video_list, f)
#
# with open('./train.pkl', 'rb') as f:
#     list2 = pkl.load(f)
# print(list2)
# print(len(list2))