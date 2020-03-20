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
echo "Start Time: $(date +"%T")">> ../../logs/mask_rcnn_execution.txt
python /content/Mask_RCNN/samples/voc/voc.py train --dataset=/content/dataset/VOCDevkit/VOC2007/ --model=imagenet --class-name=M
echo "Finish time: $(date +"%T")" >> ../../logs/mask_rcnn_execution.txt
mv snapshots/resnet50_pascal_10.h5 ../../models/resnet50_pascal_mango_yolo.h5
rm -rf snapshots/*

echo "ACFR Almonds"
echo "Start Time: $(date +"%T")">> ../../logs/mask_rcnn_execution.txt
python /content/Mask_RCNN/samples/voc/voc.py train --dataset=/content/dataset/VOCDevkit/VOC2007/ --model=imagenet --class-name=almond
echo "Finish time: $(date +"%T")" >> ../../logs/mask_rcnn_execution.txt
mv snapshots/resnet50_pascal_10.h5 ../../models/resnet50_pascal_almonds.h5
rm -rf snapshots/*

echo "ACFR Apples"
echo "Start Time: $(date +"%T")">> ../../logs/mask_rcnn_execution.txt
python /content/Mask_RCNN/samples/voc/voc.py train --dataset=/content/dataset/VOCDevkit/VOC2007/ --model=imagenet --class-name=apple
echo "Finish time: $(date +"%T")" >> ../../logs/mask_rcnn_execution.txt
mv snapshots/resnet50_pascal_10.h5 ../../models/resnet50_pascal_apples.h5
rm -rf snapshots/*

echo "ACFR Mangoes"
echo "Start Time: $(date +"%T")">> ../../logs/mask_rcnn_execution.txt
python /content/Mask_RCNN/samples/voc/voc.py train --dataset=/content/dataset/VOCDevkit/VOC2007/ --model=imagenet --class-name=mango
echo "Finish time: $(date +"%T")" >> ../../logs/mask_rcnn_execution.txt
mv snapshots/resnet50_pascal_10.h5 ../../models/resnet50_pascal_mangoes.h5
rm -rf snapshots/*

echo "WGISD Grapes"
echo "Start Time: $(date +"%T")">> ../../logs/mask_rcnn_execution.txt
python /content/Mask_RCNN/samples/voc/voc.py train --dataset=/content/dataset/VOCDevkit/VOC2007/ --model=imagenet --class-name=uva
echo "Finish time: $(date +"%T")" >> ../../logs/mask_rcnn_execution.txt
mv snapshots/resnet50_pascal_10.h5 ../../models/resnet50_pascal_wgisd.h5
rm -rf snapshots/*

echo "Evaluating Model"

# TODO: Fix
echo "Mango YOLO"
python /content/Mask_RCNN/samples/voc/voc.py test --dataset=/content/dataset/VOCDevkit/VOC2007/ --model=/content/models/mask_rcnn_mango_yolo.h5 --class-name=M
echo "ACFR Almonds"
python /content/Mask_RCNN/samples/voc/voc.py test --dataset=/content/dataset/VOCDevkit/VOC2007/ --model=/content/models/mask_rcnn_acfr_almond.h5 --class-name=almond
echo "ACFR Apples"
python /content/Mask_RCNN/samples/voc/voc.py test --dataset=/content/dataset/VOCDevkit/VOC2007/ --model=/content/models/mask_rcnn_acfr_apple.h5 --class-name=apple
echo "ACFR Mangoes"
python /content/Mask_RCNN/samples/voc/voc.py test --dataset=/content/dataset/VOCDevkit/VOC2007/ --model=/content/models/mask_rcnn_acfr_mango.h5 --class-name=mango
echo "WGISD Grapes"
python /content/Mask_RCNN/samples/voc/voc.py test --dataset=/content/dataset/VOCDevkit/VOC2007/ --model=/content/models/mask_rcnn_wgisd.h5 --class-name=uva

deactivate