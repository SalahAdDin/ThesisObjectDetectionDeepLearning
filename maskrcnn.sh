#!/bin/bash
# -- ENCODING: UTF-8 --
echo " Setting Up the System"

cd ~/Proyectos/thesis/networks/Mask_RCNN/
source bin/activate

echo "Reviewing Setup"
python -c "import tensorflow as tf; print('TensorFlow version: ', tf.__version__); print('Num GPUs Available: ', len(tf.config.experimental.list_physical_devices('GPU'))); tf.test.gpu_device_name()" >> ../../logs/mask_rcnn_execution.txt
python -c "from tensorflow.python.client import device_lib; device_lib.list_local_devices()" >> ../../logs/mask_rcnn_execution.txt

python -c "import cv2; print ('OpenCV version :  {0}'.format(cv2.__version__))" >> ../../logs/mask_rcnn_execution.txt
python -c "import keras; print('Keras version :  {0}'.format(keras.__version__))" >> ../../logs/mask_rcnn_execution.txt
python -c "import tensorflow as tf; print('TensorFlow version :  {0}'.format(tf.__version__))" >> ../../logs/mask_rcnn_execution.txt
python -c "import tensorflow as tf; print('TensorFlow Keras version :  {0}'.format(tf.keras.__version__))" >> ../../logs/mask_rcnn_execution.txt
python -c "import tensorboard as tb; print('TensorBoard version :  {0}'.format(tb.version.VERSION))" >> ../../logs/mask_rcnn_execution.txt
python -c "import numpy as np; print('NumPy version : {0}'.format(np.version.version))" >> ../../logs/mask_rcnn_execution.txt

echo "Training Net"

# TODO: Fix
# wget -P models https://github.com/fizyr/keras-models/releases/download/v0.0.1/ResNet-50-model.keras.h5

echo "MangoYOLO"
echo "Start Time: $(date +"%T")" >> ../../logs/mask_rcnn_execution.txt
python samples/voc/voc.py train --dataset=../../datasets/VOCDevkit/VOC2007/ --model=imagenet --class-name=M > ../../logs/training/mask_rcnn_mango_yolo.log
echo "Finish time: $(date +"%T")" >> ../../logs/mask_rcnn_execution.txt
mv snapshots/resnet50_pascal_10.h5 ../../models/mask_rcnn_mango_yolo.h5
rm -rf snapshots/*

echo "ACFR Almonds"
echo "Start Time: $(date +"%T")" >> ../../logs/mask_rcnn_execution.txt
python samples/voc/voc.py train --dataset=../../datasets/acfr-fruit-dataset/almonds/ --model=imagenet --class-name=almond --image-extension '.png' > ../../logs/training/mask_rcnn_almonds.log
echo "Finish time: $(date +"%T")" >> ../../logs/mask_rcnn_execution.txt
mv snapshots/resnet50_pascal_10.h5 ../../models/mask_rcnn_acfr_almond.h5
rm -rf snapshots/*

echo "ACFR Apples"
echo "Start Time: $(date +"%T")" >> ../../logs/mask_rcnn_execution.txt
python samples/voc/voc.py train --dataset=../../datasets/acfr-fruit-dataset/apples/ --model=imagenet --class-name=apple --image-extension '.png' > ../../logs/training/mask_rcnn_apples.log
echo "Finish time: $(date +"%T")" >> ../../logs/mask_rcnn_execution.txt
mv snapshots/resnet50_pascal_10.h5 ../../models/mask_rcnn_acfr_apple.h5
rm -rf snapshots/*

echo "ACFR Mangoes"
echo "Start Time: $(date +"%T")" >> ../../logs/mask_rcnn_execution.txt
python samples/voc/voc.py train --dataset=../../datasets/acfr-fruit-dataset/mangoes/ --model=imagenet --class-name=mango --image-extension '.png' > ../../logs/training/mask_rcnn_mangoes.log
echo "Finish time: $(date +"%T")" >> ../../logs/mask_rcnn_execution.txt
mv snapshots/resnet50_pascal_10.h5 ../../models/mask_rcnn_acfr_mango.h5
rm -rf snapshots/*

echo "WGISD Grapes"
echo "Start Time: $(date +"%T")" >> ../../logs/mask_rcnn_execution.txt
python samples/voc/voc.py train --dataset=../../datasets/wgisd/ --model=imagenet --class-name=uva > ../../logs/training/mask_rcnn_wgisd.log
echo "Finish time: $(date +"%T")" >> ../../logs/mask_rcnn_execution.txt
mv snapshots/resnet50_pascal_10.h5 ../../models/mask_rcnn_wgisd.h5
rm -rf snapshots/*

echo "Evaluating Model"

# TODO: Fix
echo "Mango YOLO"
python samples/voc/voc.py test --dataset=../../datasets/VOCDevkit/VOC2007/ --model=../../models/mask_rcnn_mango_yolo.h5 --class-name=M > ../../logs/evaluating/mask_rcnn_mango_yolo.log
echo "ACFR Almonds"
python samples/voc/voc.py test --dataset=../../datasets/acfr-fruit-dataset/almonds --model=../../models/mask_rcnn_acfr_almond.h5 --class-name=almond --image-extension '.png' > ../../logs/evaluating/mask_rcnn_almonds.log
echo "ACFR Apples"
python samples/voc/voc.py test --dataset=../../datasets/acfr-fruit-dataset/apples --model=../../models/mask_rcnn_acfr_apple.h5 --class-name=apple --image-extension '.png' > ../../logs/evaluating/mask_rcnn_apples.log
echo "ACFR Mangoes"
python samples/voc/voc.py test --dataset=../../datasets/acfr-fruit-dataset/mangoes --model=../../models/mask_rcnn_acfr_mango.h5 --class-name=mango --image-extension '.png' > ../../logs/evaluating/mask_rcnn_mangoes.log
echo "WGISD Grapes"
python samples/voc/voc.py test --dataset=../../datasets/wgisd --model=../../models/mask_rcnn_wgisd.h5 --class-name=uva > ../../logs/evaluating/mask_rcnn_wgisd.log

deactivate