#!/bin/bash

set -e

kubectl delete -f file-browser/ingress.yml
kubectl delete -f file-browser/service.yml
kubectl delete -f file-browser/deployment.yml
kubectl delete secret file-browser-secret
