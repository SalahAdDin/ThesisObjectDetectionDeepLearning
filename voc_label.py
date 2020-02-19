import argparse
import os
import pickle
import xml.etree.ElementTree as ET

from os import listdir, getcwd
from os.path import join

parser = argparse.ArgumentParser()
parser.add_argument("-p", "--path", help="Directory")  # Folder path
parser.add_argument("-ie", '--image-extension',
                    help='Declares the dataset images\' extension.', default='.jpg')
args = parser.parse_args()


sets = ['train', 'val', 'test']
classes = ["M", "uva", "almond", "apple", "mango"]

folder_path = args.path
annotation_folder_path = folder_path + "/Annotations/"
image_folder_path = folder_path + "/JPEGImages/"
labels_folder = os.path.join(os.path.abspath(folder_path), 'labels/')


def convert(size, box):
    dw = 1./size[0]
    dh = 1./size[1]
    x = (box[0] + box[1])/2.0
    y = (box[2] + box[3])/2.0
    w = box[1] - box[0]
    h = box[3] - box[2]
    x = x*dw
    w = w*dw
    y = y*dh
    h = h*dh
    return (x, y, w, h)


def convert_annotation(image_id):
    in_file = open(os.path.join(os.path.abspath(
        annotation_folder_path), '{}.xml'.format(image_id)))
    out_file = open(os.path.join(
        labels_folder, '{}.txt'.format(image_id)), 'w')
    tree = ET.parse(in_file)
    root = tree.getroot()
    size = root.find('size')
    w = int(size.find('width').text)
    h = int(size.find('height').text)

    for obj in root.iter('object'):
        difficult = obj.find('difficult').text
        cls = obj.find('name').text
        if cls not in classes or int(difficult) == 1:
            continue
        cls_id = classes.index(cls)
        xmlbox = obj.find('bndbox')
        b = (float(xmlbox.find('xmin').text), float(xmlbox.find('xmax').text), float(
            xmlbox.find('ymin').text), float(xmlbox.find('ymax').text))
        bb = convert((w, h), b)
        out_file.write(str(cls_id) + " " +
                       " ".join([str(a) for a in bb]) + '\n')


for image_set in sets:
    print(labels_folder)
    if not os.path.exists(labels_folder):
        os.makedirs(labels_folder)

    image_ids = open(os.path.join(os.path.abspath(
        folder_path), 'ImageSets/Main/{}.txt'.format(image_set))).read().strip().split()
    list_file = open(os.path.join(os.path.abspath(
        folder_path), '{}.txt'.format(image_set)), 'w')
    for image_id in image_ids:

        list_file.write(os.path.join(os.path.abspath(
            image_folder_path), '{}{}\n'.format(image_id, args.image_extension)))
        convert_annotation(image_id)
    list_file.close()
