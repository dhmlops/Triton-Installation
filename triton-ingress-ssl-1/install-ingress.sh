#!/bin/bash

sh ssl01-secret-triton.sh

kubectl apply -f ssl02-issuer-triton.yaml

kubectl apply -f ssl03a-ingress-triton-api.yaml
kubectl apply -f ssl03a-ingress-triton-grpc.yaml
kubectl apply -f ssl03a-ingress-triton-metrics.yaml

