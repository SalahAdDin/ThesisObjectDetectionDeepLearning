#!/bin/bash
# -- ENCODING: UTF-8 --
echo " Setting Up the System"

# Upgrading the system
sudo apt update && sudo apt upgrade
sudo apt -y install linux-headers-$(uname -r)
# TODO: Review required packages
sudo apt -y install curl cmake build-essential libavcodec-dev libavformat-dev libswscale-dev libtbb2 libtbb-dev libjpeg-dev libpng-dev libtiff-dev libjasper-dev libdc1394-22-dev libomp-dev software-properties-common unzip

# Reboot

echo "Installing nVidia driver"
# Add NVIDIA package repositories
wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/cuda-repo-ubuntu1804_10.1.243-1_amd64.deb
sudo apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/7fa2af80.pub
sudo dpkg -i cuda-repo-ubuntu1804_10.1.243-1_amd64.deb
sudo apt-get update
wget http://developer.download.nvidia.com/compute/machine-learning/repos/ubuntu1804/x86_64/nvidia-machine-learning-repo-ubuntu1804_1.0.0-1_amd64.deb
sudo apt install ./nvidia-machine-learning-repo-ubuntu1804_1.0.0-1_amd64.deb
sudo apt-get update

# Install NVIDIA driver
sudo apt-get install --no-install-recommends nvidia-driver-430
# Reboot. Check that GPUs are visible using the command: nvidia-smi

# Install development and runtime libraries (~4GB)
sudo apt-get install --no-install-recommends \
    cuda-10-1 \
    libcudnn7=7.6.4.38-1+cuda10.1  \
    libcudnn7-dev=7.6.4.38-1+cuda10.1


# Install TensorRT. Requires that libcudnn7 is installed above.
sudo apt-get install -y --no-install-recommends libnvinfer6=6.0.1-1+cuda10.1 \
    libnvinfer-dev=6.0.1-1+cuda10.1 \
    libnvinfer-plugin6=6.0.1-1+cuda10.1

# https://docs.nvidia.com/cuda/cuda-installation-guide-linux/index.html#post-installation-actions
export PATH=/usr/local/cuda-10.1/bin:/usr/local/cuda-10.1/NsightCompute-2019.1${PATH:+:${PATH}}
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/cuda/extras/CUPTI/lib64

sudo apt autoremove

sudo apt install python3-virtualenv
sudo pip3 install opencv-python vtk gdown

echo "Creating project folder"
# Creating the project folder structure
# mkdir Proyectos
# mkdir Proyectos/thesis
mkdir datasets
mkdir networks
mkdir logs
mkdir logs/training
mkdir logs/evaluating
mkdir models
mkdir images

echo "Reviewing setup"
lsb_release -a && free -m && nvcc --version && gcc -v && lscpu >> logs/setup.log
nvidia-smi >> logs/setup.log
cat /proc/meminfo >> logs/setup.log
./usr/local/cuda/extras/demo_suite/deviceQuery >> logs/setup.log

# Getting the datasets
echo "Getting datasets"
# TODO: review this
cd datasets
git clone https://github.com/avadesh02/MangoNet-Semantic-Dataset
git clone https://github.com/thsant/wgisd wgisd_yolo
gdown https://drive.google.com/uc?id=1iZbPYck5BuIsZ9GQCSHI4LlqMyxmCrP9
unzip MangoYOLO.zip
gdown https://drive.google.com/uc?id=1L2feEdder8H5U1G5FjH6lsx6u3yapXfx
unzip wgisd.zip
gdown https://drive.google.com/uc?id=1d0DXYLCAZHrL4RudWP_4Gty46MSRH4_G
unzip acfr-fruit-dataset.zip

# Cloning the networks
echo "Cloning networks"
cd networks
git clone https://github.com/SalahAdDin/Mask_RCNN.git --branch voc --single-branch
git clone https://github.com/SalahAdDin/keras-retinanet.git --branch exps --single-branch
git clone https://github.com/AlexeyAB/darknet

# Setting up the nets
echo "Setting up RetinaNet"
virtualenv -p python3 keras-retinanet/
cd keras-retinanet/
source bin/activate
pip install -U pip
pip install numpy tensorflow
pip install .
pip install -U keras
python setup.py build_ext --inplace
deactivate

echo "Setting up Mask RCNN"
virtualenv -p python3 Mask_RCNN/
cd ../Mask_RCNN/
source bin/activate
pip install -r requirements.txt
pip install -U tensorflow-gpu==1.15
python setup.py install
deactivate

echo "Setting up Darknet"
cd ../darknet/

sed -i 's/GPU=0/GPU=1/g' Makefile
sed -i 's/CUDNN=0/CUDNN=1/g' Makefile
sed -i 's/CUDNN_HALF=0/CUDNN_HALF=1/g' Makefile
sed -i 's/OPENCV=0/OPENCV=1/g' Makefile

cat Makefile

make

cd ~/Proyectos/thesis
mv voc_label.py networks/darknet/
mv yolov3-voc.cfg networks/darknet/
