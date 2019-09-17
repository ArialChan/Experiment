import json


def get_category_list(data):
    video_list = []
    for item in range(len(data['videos'])):
        if data['videos'][item]['category'] == 3:
            # print(data['videos'][item])
            video_list.append(data['videos'][item]['video_id'])

    return video_list

if __name__ == '__main__':
    with open('./exp/data/MSR-VTT/train_val_videodatainfo.json', 'rb') as file:
        data = json.load(file)
    trainval_cat_list = get_category_list(data)
    print(len(trainval_cat_list))
    print(trainval_cat_list)


    with open('./exp/data/MSR-VTT/test_videodatainfo.json', 'rb') as file:
        data = json.load(file)
    test_cat_list = get_category_list(data)
    print(len(test_cat_list))
    print(test_cat_list)

    cat_list = trainval_cat_list + test_cat_list
    print(len(cat_list))
    print(cat_list)