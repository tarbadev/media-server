#!/bin/bash

set -e


kubectl apply -f file-browser/persistent-volume.yml
kubectl apply -f file-browser/persistent-volume-claim.yml
kubectl apply -f file-browser/deployment.yml
kubectl apply -f file-browser/service.yml
kubectl apply -f file-browser/ingress.yml
