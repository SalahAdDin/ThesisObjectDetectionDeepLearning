#!/bin/bash
# -- ENCODING: UTF-8 --
echo " Setting Up the System"

cd ~/Proyectos/thesis/networks/keras-retinanet/
source bin/activate

echo "Reviewing Setup"
python -c "import tensorflow as tf; print('TensorFlow version: ', tf.__version__); print('Num GPUs Available: ', len(tf.config.experimental.list_physical_devices('GPU'))); tf.test.gpu_device_name()" >> ../../logs/retinanet_execution.txt
python -c "from tensorflow.python.client import device_lib; device_lib.list_local_devices()" >> ../../logs/retinanet_execution.txt

python -c "import cv2; print ('OpenCV version :  {0}'.format(cv2.__version__))" >> ../../logs/retinanet_execution.txt
python -c "import keras; print('Keras version :  {0}'.format(keras.__version__))" >> ../../logs/retinanet_execution.txt
python -c "import tensorflow as tf; print('TensorFlow version :  {0}'.format(tf.__version__))" >> ../../logs/retinanet_execution.txt
python -c "import tensorboard as tb; print('TensorBoard version :  {0}'.format(tb.version.VERSION))" >> ../../logs/retinanet_execution.txt

echo "Training Net"

echo "MangoYOLO"
echo "Start Time: $(date +"%T")">> ../../logs/retinanet_execution.txt
keras_retinanet/bin/train.py --random-transform --batch-size 8 --steps 500 --epochs 10 pascal ../../datasets/VOCDevkit/VOC2007 > ../../logs/training/retinanet_mango_yolo.log
echo "Finish time: $(date +"%T")" >> ../../logs/retinanet_execution.txt
mv snapshots/resnet50_pascal_10.h5 ../../models/resnet50_pascal_mango_yolo.h5
rm -rf snapshots/*

echo "ACFR Almonds"
echo "Start Time: $(date +"%T")">> ../../logs/retinanet_execution.txt
keras_retinanet/bin/train.py --random-transform --batch-size 8 --steps 500 --epochs 10 pascal --image-extension '.png' ../../datasets/acfr-fruit-dataset/almonds > ../../logs/training/retinanet_almonds.log
echo "Finish time: $(date +"%T")" >> ../../logs/retinanet_execution.txt
mv snapshots/resnet50_pascal_10.h5 ../../models/resnet50_pascal_almonds.h5
rm -rf snapshots/*

echo "ACFR Apples"
echo "Start Time: $(date +"%T")">> ../../logs/retinanet_execution.txt
keras_retinanet/bin/train.py --random-transform --batch-size 8 --steps 500 --epochs 10 pascal --image-extension '.png'../../datasets/acfr-fruit-dataset/apples > ../../logs/training/retinanet_apples.log
echo "Finish time: $(date +"%T")" >> ../../logs/retinanet_execution.txt
mv snapshots/resnet50_pascal_10.h5 ../../models/resnet50_pascal_apples.h5
rm -rf snapshots/*

echo "ACFR Mangoes"
echo "Start Time: $(date +"%T")">> ../../logs/retinanet_execution.txt
keras_retinanet/bin/train.py --random-transform --batch-size 8 --steps 500 --epochs 10 pascal --image-extension '.png'../../datasets/acfr-fruit-dataset/mangoes > ../../logs/training/retinanet_mangoes.log
echo "Finish time: $(date +"%T")" >> ../../logs/retinanet_execution.txt
mv snapshots/resnet50_pascal_10.h5 ../../models/resnet50_pascal_mangoes.h5
rm -rf snapshots/*

echo "WGISD Grapes"
echo "Start Time: $(date +"%T")">> ../../logs/retinanet_execution.txt
keras_retinanet/bin/train.py --random-transform --batch-size 8 --steps 500 --epochs 10 pascal ../../datasets/wgisd > ../../logs/training/retinanet_wgisd.log
echo "Finish time: $(date +"%T")" >> ../../logs/retinanet_execution.txt
mv snapshots/resnet50_pascal_10.h5 ../../models/resnet50_pascal_wgisd.h5
rm -rf snapshots/*

echo "Evaluating Model"

echo "Mango YOLO"
keras_retinanet/bin/evaluate.py --convert-model --iou-threshold 0.3 --save-path ../../images pascal ../../datasets/VOCDevkit/VOC2007/ ../../models/resnet50_pascal_mango_yolo.h5 > logs/evaluating/retinanet_mango_yolo.log
echo "WGISD Grapes"
keras_retinanet/bin/evaluate.py --convert-model --iou-threshold 0.3 --save-path ../../images pascal ../../datasets/wgisd/ ../../models/resnet50_pascal_wgisd.h5 > logs/evaluating/retinanet_wgisd.log
echo "ACFR Almonds"
keras_retinanet/bin/evaluate.py --convert-model --iou-threshold 0.3 --save-path ../../images pascal --image-extension '.png' ../../datasets/acfr-fruit-dataset/almonds/ ../../models/resnet50_pascal_almonds.h5 > logs/evaluating/retinanet_almonds.log
echo "ACFR Apples"
keras_retinanet/bin/evaluate.py --convert-model --iou-threshold 0.3 --save-path ../../images pascal --image-extension '.png' ../../datasets/acfr-fruit-dataset/apples/ ../../models/resnet50_pascal_apples.h5 > logs/evaluating/retinanet_apples.log
echo "ACFR Mangoes"
keras_retinanet/bin/evaluate.py --convert-model --iou-threshold 0.3 --save-path ../../images pascal --image-extension '.png' ../../datasets/acfr-fruit-dataset/mangoes/ ../../models/resnet50_pascal_mangoes.h5 > logs/evaluating/retinanet_mangoes.log

deactivate