import pickle
import numpy as np
import pandas as pd

def csv_to_sentences(csv_data):
    np_data = np.asarray(csv_data)

    i = [1, 0] # video name과 caption 자리 바꾸기 위해

    # video의 캡션의 개수가 20개가 되지 않으면 자동으로 20개까지 채워준다.
    sentences = []
    count = 0
    before = ""
    for k in range(len(np_data)):

        if (np_data[k][0] != before and count != 0):
            l = 20 - count
            for j in range(l):
                sentences.append(tuple(np_data[k-(count-j%count)][i]))
            before = ""
            count = 0

        count = (count + 1) % 20
        # print(np_data[k][0], k)
        sentences.append(tuple(np_data[k][i]))
        before = np_data[k][0]

        if (k==len(np_data)-1 and count!=0):
            l = 20 - count
            for j in range(l):
                sentences.append(tuple(np_data[k+1 - (count - j % count)][i]))

    # print(sentences)
    print(len(sentences))

    return sentences

def convert_to_id(word_to_id, sentences):
    vid_sent_map = {}
    for sent in sentences:
        temp = sent[0].split(' ')
        ind_sent = []
        ind_sent.append(word_to_id["<START>"])
        for word in temp:
            try:
                ind_sent.append(word_to_id[word])
            except:
                ind_sent.append(word_to_id["<UNK>"])
        ind_sent.append(word_to_id["<END>"])
        try:
            vid_sent_map[sent[1]].append(ind_sent)
        except:
            vid_sent_map[sent[1]] = [ind_sent]
    return vid_sent_map

def format_gts(vid_to_caption_map, id_to_word):
    temp = []
    for video_id in vid_to_caption_map.keys():
        for caption in vid_to_caption_map[video_id]:
            processed_caption = " ".join([id_to_word[id] for id in caption[1:]])
            temp.append({'caption' : processed_caption, 'image_id' : video_id})
    print(len(temp))
    gts = {}
    gts["annotations"] = temp
    # print(gts['annotations'])
    # print(gts)
    with open('gts_luna.pkl', "wb") as file:
        pickle.dump(gts, file)


if __name__ == '__main__':
    csv_data = pd.read_csv('captioning.csv')

    sentences = csv_to_sentences(csv_data)

    vocab_file = "./meta_data/vocab.pkl"
    with open(vocab_file, "rb") as file:
        vocab_list = pickle.load(file)
    vid_to_caption = convert_to_id(vocab_list, sentences)
    print(vid_to_caption)
    with open('luna_vid_to_caption.pkl', "wb") as file:
        pickle.dump(vid_to_caption, file)

    id_to_word = {v: k for k, v in vocab_list.items()}

    format_gts(vid_to_caption, id_to_word)