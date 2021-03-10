# Triton Installation (offline)

## ===== Setup Triton Server ======
https://github.com/triton-inference-server/server/blob/master/docs/quickstart.md#install-triton-docker-image

### 1. Get these info ready for configurations
- Assigned ip and 3 x ports number (HttpService, GRPCInferenceService, Metrics Service) for Triton Server
- S3 ip, port, access key and password

### 2. Load docker image
```bash
docker load --input docker_image/triton-20.12.tar
```

Note: The docker image is not uploaded to Github due to its size. To setup on your own machine, you can download the image.
```bash
docker pull nvcr.io/nvidia/tritonserver:20.12-py3
```

### 3. Install Nvidia-Docker2
This is required for docker to use GPU. 
Check if already installed. 
```bash
nvidia-docker version
```
Otherwise, install using the scripts below.

```bash
distribution=$(. /etc/os-release;echo $ID$VERSION_ID) \
   && curl -s -L nvidia-docker2/gpgkey | sudo apt-key add - \
   && curl -s -L nvidia-docker2/$distribution/nvidia-docker.list | sudo tee /etc/apt/sources.list.d/nvidia-docker.list
   
sudo apt-get update
sudo apt install nvidia-docker2/$distribution/amd64/nvidia-docker2_2.5.0-1_all.deb
```

### 4. Setup S3 for Triton
- Create bucket for model repository in S3. 
- Add mnist_tf_savedmodel/... (sample model) to model bucket. For testing purpose only, to be removed after testing.

### 5. Run Triton Docker with GPU support
```bash
# Using S3 storage
# --gpus=1 flag indicates that 1 system GPU should be made available to Triton for inferencing.
docker run --gpus=<how_many_gpus> --rm --shm-size=1g --ulimit memlock=-1 --ulimit stack=67108864 -p<http_port>:8000 -p<grpc_port>:8001 -p<metrics_port>:8002 nvcr.io/nvidia/tritonserver:20.12-py3 tritonserver -e AWS_ACCESS_KEY_ID=<accesskey> -e AWS_SECURE_ACCESS_KEY=<password> --model-repository=s3://<s3 ip>:<s3 port>/<bucket_for_model>
```

```bash
# Using local storage
docker run --gpus=<how_many_gpus> --rm --shm-size=1g --ulimit memlock=-1 --ulimit stack=67108864 -p<http_port>:8000 -p<grpc_port>:8001 -p<metrics_port>:8002 -v <path_to_your_model_repository>:/models nvcr.io/nvidia/tritonserver:20.12-py3 tritonserver --model-repository=/models
```

You should see your model with its version and status 'READY' after running the script above to run Triton docker.
```bash
+----------------------+---------+--------+
| Model                | Version | Status |
+----------------------+---------+--------+
| <model_name>         | <v>     | READY  |
| ..                   | .       | ..     |
| ..                   | .       | ..     |
+----------------------+---------+--------+
```

Note: 
- For running Triton with CPU ONLY, remove the flag --gpus. 

### 6. Verify Triton is running correctly.
```bash
# The HTTP request returns status 200 if Triton is ready and non-200 if it is not ready.
curl -v <triton_ip>:<http_port>/v2/health/ready

...
< HTTP/1.1 200 OK
< Content-Length: 0
< Content-Type: text/plain
```


## ===== Further Testing the offline setup ===== 
https://github.com/kubeflow/kfserving/blob/master/docs/predict-api/v2/required_api.md

### Check model health
```bash
# GET v2/models/${MODEL_NAME}/versions/${MODEL_VERSION}/ready
# if http 200 returns, means model is OK. 
# E.g. curl -X GET http://0.0.0.0:8000/v2/health/ready
curl -X GET http://<triton_ip>:<triton_port>/v2/models/mnist_tf_savedmodel/versions/1/ready
```

### Get model metadata
```bash
# GET v2/models/${MODEL_NAME}/versions/${MODEL_VERSION}
# Should get a json of model's metadata which is what are defined in model's config.pbtxt in S3. 
curl -X GET http://<triton_ip>:<triton_port>/v2/models/mnist_tf_savedmodel/versions/1
```

### Do model inference
***** WIP ***** to get it working. Pending understanding on how to define the data field in the http request body. 
```bash
# POST v2/models/${MODEL_NAME}[/versions/${MODEL_VERSION}]/infer
curl -X POST http://<triton_ip>:<triton_port>/v2/mnist_tf_savedmodel/versions/1 -<add http body>
```

## References
1. https://github.com/triton-inference-server/server/blob/master/docs/quickstart.md#install-triton-docker-image
2. https://github.com/kubeflow/kfserving/blob/master/docs/predict-api/v2/required_api.md
3. https://stackoverflow.com/questions/41802816/how-to-check-nvidia-docker-version



