#!/bin/bash

sh ssl01-secret-triton.sh

kubectl apply -f ssl02-issuer-triton.yaml

kubectl apply -f ssl03-ingress-triton.yaml



