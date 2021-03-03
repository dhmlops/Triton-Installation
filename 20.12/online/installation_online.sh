#!/bin/bash

# online installation
echo ===== online installation =====

echo ----- pull triton docker image ----
docker pull nvcr.io/nvidia/tritonserver:20.12-py3
echo show docker images
docker images
read -p "Docker image pulled. Check if the Triton docker image is present in the docker images list. Press Enter to continue ..."

echo ----- nvidia-container-toolkit setup ------
echo setup stable repo and GPG key ...
distribution=$(. /etc/os-release;echo $ID$VERSION_ID) \
   && curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | sudo apt-key add - \
   && curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | sudo tee /etc/apt/sources.list.d/nvidia-docker.list

echo install nvidia-docker2 ...
sudo apt-get update
sudo apt-get install -y nvidia-docker2
read -p "Nvidia-Docker2 installed. Press Enter to continue ..."

echo restarting docker ...
sudo systemctl restart docker
read -p "Docker restarted. Press Enter to continue ..."


read -p "Proceed with client libraries installation.  Press Enter to continue ..."


echo install client dependencies ...
# install triton client libraries
pip3 install nvidia-pyindex
pip3 install tritonclient[all]

# install client dependencies
pip3 install Pillow


read -p "Press Enter to end the installation!! Start the triton docker container after this installation."
