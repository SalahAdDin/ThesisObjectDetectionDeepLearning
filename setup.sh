#!/bin/bash
# -- ENCODING: UTF-8 --
echo " Setting Up the System"

# Upgrading the system
sudo apt update && sudo apt upgrade
sudo apt -y install linux-headers-$(uname -r)
sudo apt -y install curl cmake build-essential libavcodec-dev libavformat-dev libswscale-dev libtbb2 libtbb-dev libjpeg-dev libpng-dev libtiff-dev libjasper-dev libdc1394-22-dev libomp-dev software-properties-common

# Reboot

echo "Installing nVidia driver"
# Add NVIDIA package repositories
wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/cuda-repo-ubuntu1804_10.1.243-1_amd64.deb
sudo dpkg -i cuda-repo-ubuntu1804_10.1.243-1_amd64.deb
sudo apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/7fa2af80.pub
sudo apt-get update
wget http://developer.download.nvidia.com/compute/machine-learning/repos/ubuntu1804/x86_64/nvidia-machine-learning-repo-ubuntu1804_1.0.0-1_amd64.deb
sudo apt install ./nvidia-machine-learning-repo-ubuntu1804_1.0.0-1_amd64.deb
sudo apt-get update

# Install NVIDIA driver
sudo apt-get install --no-install-recommends nvidia-driver-418
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
export LD_LIBRARY_PATH=/usr/local/cuda-10.1/lib64${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}

sudo apt autoremove

nvidia-smi
lsb_release -a && free -m && nvcc --version && gcc -v && lscpu
./usr/local/cuda/extras/demo_suite/deviceQuery

sudo apt install python3-virtualenv
sudo pip3 install opencv-python vtk

echo "Creating project folder"
# Creating the project folder structure
mkdir Proyectos
mkdir Proyectos/thesis
mkdir Proyectos/thesis/datasets
mkdir Proyectos/thesis/networks

# Getting the datasets
echo "Getting datasets"
cd Proyectos/thesis/datasets
git clone https://github.com/avadesh02/MangoNet-Semantic-Dataset
git clone https://github.com/SalahAdDin/wgisd
git clone https://github.com/SalahAdDin/acfr-fruit-dataset

# Cloning the networks
echo "Cloning networks"
cd ~/Proyectos/thesis/networks
git clone https://github.com/matterport/Mask_RCNN
git clone https://github.com/fizyr/keras-retinanet
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
python setup.py install
deactivate

echo "Setting up Darknet"
cd ../darknet/
mkdir build-release
cd build-release
cmake ..
make
make install
