#!/bin/bash

echo check GPU usage
nvidia-smi
read -p "Press Enter to continue ..."

echo get list of used ports
sudo lsof -i -P -n | grep LISTEN
read -p "Press Enter to continue ..."

echo python version
python3 -V

echo check python packages availability
# triton client dependencies
echo "
To run the clients the following dependencies must be installed.

apt-get install -y --no-install-recommends \
        curl \
        libopencv-dev=3.2.0+dfsg-4ubuntu0.1 \
        libopencv-core-dev=3.2.0+dfsg-4ubuntu0.1 \
        pkg-config \
        python3 \
        python3-pip \
        python3-dev

python3 -m pip install --upgrade wheel setuptools
python3 -m pip install --upgrade grpcio-tools numpy pillow
"

pip3 list | grep tritonclient
pip3 list | grep wheel
pip3 list | grep curl
pip3 list | grep libopencv-dev
pip3 list | grep libopencv-core
pip3 list | grep pkg-config
pip3 list | grep python3-dev
pip3 list | grep python3-pip
pip3 list | grep setuptools
pip3 list | grep grpcio-tools
pip3 list | grep numpy
pip3 list | grep Pillow


