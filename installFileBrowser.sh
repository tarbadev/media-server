#!/bin/bash

set -e

kubectl create secret generic file-browser-secret --from-file=file-browser/users.json
kubectl apply -f file-browser/deployment.yml
kubectl apply -f file-browser/service.yml
kubectl apply -f file-browser/ingress.yml
