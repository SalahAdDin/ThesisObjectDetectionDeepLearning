import cv2
import os
import pandas as pd
from xml.etree import ElementTree as ET

class_name = "uva"
folder_name = "wgisd"
folder_path ="datasets/wgisd/"
annotation_folder_path = folder_path + "Annotations/"
image_folder_path = folder_path + "JPEGImages/"

fields = ['CLASS', 'CX', 'CY', 'W', 'H']
depth = 3

# load the folder
for path, dirs, files in os.walk(annotation_folder_path):
        print("Analyzing {}".format(path))
        for each_file in files:
            # The path variable gets updated for each subfolder
            file_path = os.path.join(os.path.abspath(path), each_file)
            print(each_file)
            # load each file in the folder
            df = pd.read_csv(file_path, sep=' ', names = fields)
            # get the name of the file
            fn = each_file.replace(".txt", ".jpg")

            # get the height and width of the image
            image_path = os.path.join(os.path.abspath(image_folder_path), fn)
            img = cv2.imread(image_path)
            height, width, channels = img.shape

            # creating the XML file
            annotation = ET.Element('annotation')
            ET.SubElement(annotation, 'folder').text = folder_name
            ET.SubElement(annotation, 'filename').text = fn
            ET.SubElement(annotation, 'path').text = image_path
            src = ET.SubElement(annotation, 'source')
            ET.SubElement(src,'database').text='Unknown'
            size = ET.SubElement(annotation, 'size')
            ET.SubElement(size, 'width').text = str(width)
            ET.SubElement(size, 'height').text = str(height)
            ET.SubElement(size, 'depth').text = str(depth)
            ET.SubElement(annotation, 'segmented').text = '0'

            for i in range(0, len(df)):
                ob = ET.SubElement(annotation, 'object')
                ET.SubElement(ob, 'name').text = class_name
                ET.SubElement(ob, 'pose').text = 'Unspecified'
                ET.SubElement(ob, 'truncated').text = '0'
                ET.SubElement(ob, 'difficult').text = '0'
                bbox = ET.SubElement(ob, 'bndbox')
                

                bbox_width = df['W'].iloc[i].astype(float) * width
                bbox_height = df['H'].iloc[i].astype(float) * height
                center_x = df['CX'].iloc[i].astype(float) * width
                center_y = df['CY'].iloc[i].astype(float) * height

                ET.SubElement(bbox, 'xmin').text = str(center_x - (bbox_width / 2))
                ET.SubElement(bbox, 'ymin').text = str(center_y - (bbox_height / 2))
                ET.SubElement(bbox, 'xmax').text = str(center_x + (bbox_width / 2))
                ET.SubElement(bbox, 'ymax').text = str(center_y + (bbox_height / 2))

            tree = ET.ElementTree(annotation)
            tree.write(os.path.join(os.path.abspath(path), each_file.replace(".txt", ".xml")), encoding='utf8')


