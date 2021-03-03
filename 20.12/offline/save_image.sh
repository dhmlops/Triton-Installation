#!/bin/bash

echo saving docker image
docker save -o docker_image/triton-20.12.tar nvcr.io/nvidia/tritonserver:20.12-py3

echo docker image saved!!
