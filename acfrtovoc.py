import argparse
import cv2
import os
import pandas as pd
from xml.etree import ElementTree as ET

# Create arguments to pass to the script in the shell
parser = argparse.ArgumentParser()
parser.add_argument("-p","--path", help="Directory")  # Folder path
parser.add_argument("-cn", "--class_name", help="Object class") # Folder object class
parser.add_argument("-s", "--shape", default='square', help="Object class") # Folder object class
args = parser.parse_args()

print(args)

class_name = args.class_name
folder_name = os.path.basename(os.path.normpath(args.path))
folder_path = args.path

annotation_folder_path = folder_path + "/Annotations/"
image_folder_path = folder_path + "/JPEGImages/"

print(annotation_folder_path, image_folder_path)

square_fields = ['#item','x','y','dx','dy','label']
circle_fields = ['#item','c-x','c-y','radius','label']
depth = 3

# load the folder
for path, dirs, files in os.walk(annotation_folder_path):
        print("Analyzing {}".format(path))
        for each_file in files:
            # The path variable gets updated for each subfolder
            file_path = os.path.join(os.path.abspath(path), each_file)
            print(each_file)
            # load each file in the folder
            if args.shape == 'square':
                df = pd.read_csv(file_path, usecols=square_fields)
            elif args.shape == 'circle':
                df = pd.read_csv(file_path, usecols=circle_fields)

            # get the name of the image file
            fn = each_file.replace(".csv", ".png")

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

                if args.shape == 'square':
                    xmin = df['x'].iloc[i]
                    ymin = df['y'].iloc[i]
                    xmax = xmin + df['dx'].iloc[i]
                    ymax = ymin + df['dy'].iloc[i]
                elif args.shape == 'circle':
                    xmin = df['c-x'].iloc[i] - df['radius'].iloc[i]
                    ymin = df['c-y'].iloc[i] - df['radius'].iloc[i]
                    xmax = df['c-x'].iloc[i] + df['radius'].iloc[i]
                    ymax = df['c-y'].iloc[i] + df['radius'].iloc[i]

                ET.SubElement(bbox, 'xmin').text = str(xmin)
                ET.SubElement(bbox, 'ymin').text = str(ymin)
                ET.SubElement(bbox, 'xmax').text = str(xmax)
                ET.SubElement(bbox, 'ymax').text = str(ymax)

            tree = ET.ElementTree(annotation)
            tree.write(os.path.join(os.path.abspath(path), each_file.replace(".csv", ".xml")), encoding='utf8')


