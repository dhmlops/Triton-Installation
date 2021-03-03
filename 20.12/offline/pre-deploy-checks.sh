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
pip3 list | grep Pillow
pip3 list | grep nvidia-pyindex
pip3 list | grep tritonclient
