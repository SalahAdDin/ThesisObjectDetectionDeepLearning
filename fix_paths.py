folder_path = '/content/darknet/dataset/wgisd'
image_folder_path = folder_path + "/data/"

sets = ['train', 'test']

for image_set in sets:
    image_ids = open(os.path.join(os.path.abspath(
        folder_path), '{}.txt'.format(image_set))).read().strip().split()
    list_file = open(os.path.join(os.path.abspath(
        folder_path), '{}.txt'.format(image_set)), 'w')
    for image_id in image_ids:
        list_file.write(os.path.join(os.path.abspath(
            image_folder_path), '{}.jpg\n'.format(image_id)))
    list_file.close()