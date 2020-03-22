#!/bin/bash
# -- ENCODING: UTF-8 --
echo " Setting Up the System"

cd ~/Proyectos/thesis/networks/darknet/

# TODO: Review paths ~/Proyectos/thesis/

echo "Reviewing Setup"

python3 -c "import cv2; print ('OpenCV version :  {0}'.format(cv2.__version__))" >> ../../logs/yolo_v3_execution.txt

echo "Generating YOLO labels"
python3 voc_label.py -p ../../datasets/VOCDevkit/VOC2007
python3 voc_label.py -ie .png -p ../../datasets/acfr-fruit-dataset/almonds
python3 voc_label.py -ie .png -p ../../datasets/acfr-fruit-dataset/apples
python3 voc_label.py -ie .png -p ../../datasets/acfr-fruit-dataset/mangoes
python3 fix_paths.py

echo "Generating data  and name files"

# TODO: Review if paths works fine in this format
# here we need the correct absolute path
echo $'classes= 1\ntrain = '$HOME'/Projects/thesis/datasets/VOCDevkit/VOC2007/train.txt\nvalid = '$HOME'/Projects/thesis/datasets/VOCDevkit/VOC2007/val.txt\nnames = '$HOME'/Projects/thesis/datasets/m.names\nbackup = '$HOME'/Projects/thesis/networks/darknet/backup/' > m.data
echo $'classes= 1\ntrain = '$HOME'/Projects/thesis/datasets/acfr-fruit-dataset/almonds/train.txt\nvalid = '$HOME'/Projects/thesis/datasets/acfr-fruit-dataset/almonds/val.txt\nnames = '$HOME'/Projects/thesis/datasets/almond.names\nbackup = '$HOME'/Projects/thesis/networks/darknet/backup/' > almond.data
echo $'classes= 1\ntrain = '$HOME'/Projects/thesis/datasets/acfr-fruit-dataset/apples/train.txt\nvalid = '$HOME'/Projects/thesis/datasets/acfr-fruit-dataset/apples/val.txt\nnames = '$HOME'/Projects/thesis/datasets/apple.names\nbackup = '$HOME'/Projects/thesis/networks/darknet/backup/' > apple.data
echo $'classes= 1\ntrain = '$HOME'/Projects/thesis/datasets/acfr-fruit-dataset/mangoes/train.txt\nvalid = '$HOME'/Projects/thesis/datasets/acfr-fruit-dataset/mangoes/val.txt\nnames = '$HOME'/Projects/thesis/datasets/mango.names\nbackup = '$HOME'/Projects/thesis/networks/darknet/backup/' > mango.data
echo $'classes= 1\ntrain = '$HOME'/Projects/thesis/datasets/wgisd_yolo/train.txt\nvalid = '$HOME'/Projects/thesis/datasets/wgisd_yolo/test.txt\nnames = '$HOME'/Projects/thesis/datasets/uva.names\nbackup = '$HOME'/Projects/thesis/networks/darknet/backup/' > uva.data

echo "m" > $HOME/Projects/thesis/datasets/m.names
echo "uva" > $HOME/Projects/thesis/datasets/uva.names
echo "almond" > $HOME/Projects/thesis/datasets/almond.names
echo "apple" > $HOME/Projects/thesis/datasets/apple.names
echo "mango" > $HOME/Projects/thesis/datasets/mango.names

echo "Training Net"

wget https://pjreddie.com/media/files/darknet53.conv.74

echo "MangoYOLO"
echo "Start Time: $(date +"%T")">> ../../logs/yolo_v3_execution.txt
./darknet detector train m.data yolov3-voc.cfg darknet53.conv.74 -dont_show > ../../logs/training/yolo_v3_mango_yolo.log
echo "Finish time: $(date +"%T")" >> ../../logs/yolo_v3_execution.txt
mv backup/yolov3-voc_final.weights ../../models/yolov3-mango-yolo.weights
rm -rf backup/*

echo "ACFR Almonds"
echo "Start Time: $(date +"%T")">> ../../logs/yolo_v3_execution.txt
./darknet detector train almond.data yolov3-voc.cfg darknet53.conv.74 -dont_show > ../../logs/training/yolo_v3_almonds.log
echo "Finish time: $(date +"%T")" >> ../../logs/yolo_v3_execution.txt
mv backup/yolov3-voc_final.weights ../../models/yolov3-acfr-almond.weights
rm -rf backup/*

echo "ACFR Apples"
echo "Start Time: $(date +"%T")">> ../../logs/yolo_v3_execution.txt
./darknet detector train apple.data yolov3-voc.cfg darknet53.conv.74 -dont_show > ../../logs/training/yolo_v3_apples.log
echo "Finish time: $(date +"%T")" >> ../../logs/yolo_v3_execution.txt
mv backup/yolov3-voc_final.weights ../../models/yolov3-acfr-apple.weights
rm -rf backup/*

echo "ACFR Mangoes"
echo "Start Time: $(date +"%T")">> ../../logs/yolo_v3_execution.txt
./darknet detector train mango.data yolov3-voc.cfg darknet53.conv.74 -dont_show > ../../logs/training/yolo_v3_mangoes.log
echo "Finish time: $(date +"%T")" >> ../../logs/yolo_v3_execution.txt
mv backup/yolov3-voc_final.weights ../../models/yolov3-acfr-mango.weights
rm -rf backup/*

echo "WGISD Grapes"
echo "Start Time: $(date +"%T")">> ../../logs/yolo_v3_execution.txt
./darknet detector train uva.data yolov3-voc.cfg darknet53.conv.74 -dont_show > ../../logs/training/yolo_v3_wgisd.log
echo "Finish time: $(date +"%T")" >> ../../logs/yolo_v3_execution.txt
mv backup/yolov3-voc_final.weights ../../models/yolov3-wgisd.weights
rm -rf backup/*

echo "Evaluating Model"

sed -i 's|valid = '$HOME'/Projects/thesis/datasets/acfr-fruit-dataset/almonds/val.txt|valid = '$HOME'/Projects/thesis/datasets/acfr-fruit-dataset/almonds/test.txt|g' almond.data
sed -i 's|valid = '$HOME'/Projects/thesis/datasets/acfr-fruit-dataset/apples/val.txt|valid = '$HOME'/Projects/thesis/datasets/acfr-fruit-dataset/apples/test.txt|g' apple.data
sed -i 's|valid = '$HOME'/Projects/thesis/datasets/acfr-fruit-dataset/mangoes/val.txt|valid = '$HOME'/Projects/thesis/datasets/acfr-fruit-dataset/mangoes/test.txt|g' mango.data
sed -i 's|valid = '$HOME'/Projects/thesis/datasets/VOCDevkit/VOC2007/val.txt|valid = '$HOME'/Projects/thesis/datasets/VOCDevkit/VOC2007/test.txt|g' m.data

echo "Mango YOLO"
./darknet detector map m.data yolov3-voc.cfg ../../models/yolov3-mango.weights -iou_thresh 0.3 > ../../logs/evaluating/yolo_v3_mango_yolo.log
echo "WGISD Grapes"
./darknet detector map uva.data yolov3-voc.cfg ../../models/yolov3-wgisd.weights -iou_thresh 0.3 > ../../logs/evaluating/yolo_v3_wgisd.log
echo "ACFR Almonds"
./darknet detector map almond.data yolov3-voc.cfg ../../models/yolov3-acfr-almond.weights -iou_thresh 0.3 > ../../logs/evaluating/yolo_v3_almonds.log
echo "ACFR Apples"
./darknet detector map apple.data yolov3-voc.cfg ../../models/yolov3-acfr-apple.weights -iou_thresh 0.3 > ../../logs/evaluating/yolo_v3_apples.log
echo "ACFR Mangoes"
./darknet detector map mango.data yolov3-voc.cfg ../../models/yolov3-acfr-mango.weights -iou_thresh 0.3 > ../../logs/evaluating/yolo_v3_mangoes.log
