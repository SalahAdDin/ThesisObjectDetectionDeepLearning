#!/bin/bash
# -- ENCODING: UTF-8 --
echo " Setting Up the System"

cd ~/Proyectos/thesis/networks/darknet/

# TODO: Review paths

echo "Reviewing Setup"
path=$(pwd)
python3 -c "import cv2; print ('OpenCV version :  {0}'.format(cv2.__version__))" >> ../../logs/yolo_v3_execution.txt

echo "Generating YOLO labels"
python3 voc_label.py -p /content/darknet/dataset/VOCDevkit/VOC2007
python3 voc_label.py -ie .png -p /content/darknet/dataset/acfr-fruit-dataset/almonds
python3 voc_label.py -ie .png -p /content/darknet/dataset/acfr-fruit-dataset/apples
python3 voc_label.py -ie .png -p /content/darknet/dataset/acfr-fruit-dataset/mangoes
python3 fix_paths.py

echo "Generating data  and name files"

echo $'classes= 1\ntrain = /content/darknet/dataset/VOCDevkit/VOC2007/train.txt\nvalid = /content/darknet/dataset/VOCDevkit/VOC2007/val.txt\nnames = /content/darknet/dataset/m.names\nbackup = /content/darknet/backup/' > m.data
echo $'classes= 1\ntrain = /content/darknet/dataset/acfr-fruit-dataset/almonds/train.txt\nvalid = /content/darknet/dataset/acfr-fruit-dataset/almonds/val.txt\nnames = /content/darknet/dataset/almond.names\nbackup = /content/darknet/backup/' > almond.data
echo $'classes= 1\ntrain = /content/darknet/dataset/acfr-fruit-dataset/apples/train.txt\nvalid = /content/darknet/dataset/acfr-fruit-dataset/apples/val.txt\nnames = /content/darknet/dataset/apple.names\nbackup = /content/darknet/backup/' > apple.data
echo $'classes= 1\ntrain = /content/darknet/dataset/acfr-fruit-dataset/mangoes/train.txt\nvalid = /content/darknet/dataset/acfr-fruit-dataset/mangoes/val.txt\nnames = /content/darknet/dataset/mango.names\nbackup = /content/darknet/backup/' > mango.data
echo $'classes= 1\ntrain = /content/darknet/dataset/wgisd/train.txt\nvalid = /content/darknet/dataset/wgisd/test.txt\nnames = /content/darknet/dataset/uva.names\nbackup = /content/darknet/backup/' > uva.data

echo "m" > m.names
echo "uva" > uva.names
echo "almond" > almond.names
echo "apple" > apple.names
echo "mango" > mango.names

echo "Training Net"

wget https://pjreddie.com/media/files/darknet53.conv.74

echo "MangoYOLO"
echo "Start Time: $(date +"%T")">> ../../logs/yolo_v3_execution.txt
./darknet detector train dataset/m.data dataset/yolov3-voc.cfg darknet53.conv.74 -dont_show > ../../logs/training/yolo_v3_mango_yolo.log
echo "Finish time: $(date +"%T")" >> ../../logs/yolo_v3_execution.txt
mv backup/yolov3-voc_final.weights ../../models/yolov3-mango-yolo.weights
rm -rf backup/*

echo "ACFR Almonds"
echo "Start Time: $(date +"%T")">> ../../logs/yolo_v3_execution.txt
./darknet detector train dataset/almond.data dataset/yolov3-voc.cfg darknet53.conv.74 -dont_show > ../../logs/training/yolo_v3_almonds.log
echo "Finish time: $(date +"%T")" >> ../../logs/yolo_v3_execution.txt
mv backup/yolov3-voc_final.weights ../../models/yolov3-acfr-almond.weights
rm -rf backup/*

echo "ACFR Apples"
echo "Start Time: $(date +"%T")">> ../../logs/yolo_v3_execution.txt
./darknet detector train dataset/apple.data dataset/yolov3-voc.cfg darknet53.conv.74 -dont_show > ../../logs/training/yolo_v3_apples.log
echo "Finish time: $(date +"%T")" >> ../../logs/yolo_v3_execution.txt
mv backup/yolov3-voc_final.weights ../../models/yolov3-acfr-apple.weights
rm -rf backup/*

echo "ACFR Mangoes"
echo "Start Time: $(date +"%T")">> ../../logs/yolo_v3_execution.txt
./darknet detector train dataset/mango.data dataset/yolov3-voc.cfg darknet53.conv.74 -dont_show > ../../logs/training/yolo_v3_mangoes.log
echo "Finish time: $(date +"%T")" >> ../../logs/yolo_v3_execution.txt
mv backup/yolov3-voc_final.weights ../../models/yolov3-acfr-mango.weights
rm -rf backup/*

echo "WGISD Grapes"
echo "Start Time: $(date +"%T")">> ../../logs/yolo_v3_execution.txt
./darknet detector train dataset/uva.data dataset/yolov3-voc.cfg darknet53.conv.74 -dont_show > ../../logs/training/yolo_v3_wgisd.log
echo "Finish time: $(date +"%T")" >> ../../logs/yolo_v3_execution.txt
mv backup/yolov3-voc_final.weights ../../models/yolov3-wgisd.weights
rm -rf backup/*

echo "Evaluating Model"

sed -i 's|valid = /content/darknet/dataset/acfr-fruit-dataset/almonds/val.txt|valid = /content/darknet/dataset/acfr-fruit-dataset/almonds/test.txt|g' dataset/almond.data
sed -i 's|valid = /content/darknet/dataset/acfr-fruit-dataset/apples/val.txt|valid = /content/darknet/dataset/acfr-fruit-dataset/apples/test.txt|g' dataset/apple.data
sed -i 's|valid = /content/darknet/dataset/acfr-fruit-dataset/mangoes/val.txt|valid = /content/darknet/dataset/acfr-fruit-dataset/mangoes/test.txt|g' dataset/mango.data
sed -i 's|valid = /content/darknet/dataset/VOCDevkit/VOC2007/val.txt|valid = /content/darknet/dataset/VOCDevkit/VOC2007/test.txt|g' dataset/m.data

echo "Mango YOLO"
./darknet detector map dataset/m.data dataset/yolov3-voc.cfg /content/models/yolov3-mango.weights -iou_thresh 0.3
echo "WGISD Grapes"
./darknet detector map dataset/uva.data dataset/yolov3-voc.cfg /content/models/yolov3-wgisd.weights -iou_thresh 0.3
echo "ACFR Almonds"
./darknet detector map dataset/almond.data dataset/yolov3-voc.cfg /content/models/yolov3-acfr-almond.weights -iou_thresh 0.3
echo "ACFR Apples"
./darknet detector map dataset/apple.data dataset/yolov3-voc.cfg /content/models/yolov3-acfr-apple.weights -iou_thresh 0.3
echo "ACFR Mangoes"
./darknet detector map dataset/mango.data dataset/yolov3-voc.cfg /content/models/yolov3-acfr-mango.weights -iou_thresh 0.3
