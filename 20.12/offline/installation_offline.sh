#!/bin/bash

# offline installation

echo offline installation started ....
read -p "script directory: ${PWD}   Press any key to continue ..."

echo ------ load docker image ------
docker load --input ${PWD}/docker_image/triton-20.12.tar
echo show docker images
docker images
read -p "Docker image loaded. Check if the Triton docker image is present in the docker images list. Press Enter to continue ..."

echo ------ nvidia-container-toolkit setup ------
echo setup stable repo and GPG key ...
distribution=$(. /etc/os-release;echo $ID$VERSION_ID) \
   && curl -s -L ${PWD}/nvidia-docker2/gpgkey | sudo apt-key add - \
   && curl -s -L ${PWD}/nvidia-docker2/$distribution/nvidia-docker.list | sudo tee /etc/apt/sources.list.d/nvidia-docker.list
read -p "Setup stable repo and GPG key done. Press Enter to continue ..."

echo install nvidia-docker2 ...
sudo apt-get update
sudo apt install ${PWD}/nvidia-docker2/$distribution/amd64/nvidia-docker2_2.5.0-1_all.deb
read -p "Nvidia-Docker2 installed. Press Enter to continue ..."

echo restarting docker ...
sudo systemctl restart docker
read -p "Docker restarted. Press Enter to continue ..."


read -p "Proceed with client libraries installation.  Press Enter to continue ..."


echo install client dependencies ...
# install triton client libraries
python3 -m pip install --upgrade ${PWD}/python_packages/grpcio_tools-1.36.1-cp39-cp39-manylinux2014_x86_64.whl
python3 -m pip install --upgrade ${PWD}/python_packages/wheel-0.36.2-py2.py3-none-any.whl
python3 -m pip install --upgrade ${PWD}/tritonclient2.6.0/tritonclient-2.6.0-py3-none-any.whl

# install other client dependencies
python3 -m pip install --upgrade ${PWD}/python_packages/Pillow-8.1.1-cp39-cp39-manylinux1_x86_64.whl


read -p "Press Enter to end the installation!! Start the triton docker container after this installation."
