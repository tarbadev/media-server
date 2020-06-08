#!/bin/bash

set -e

kubectl create configmap prometheus-config --from-file prometheus/prometheus.yml --namespace=monitoring

kubectl apply -f prometheus/deployment.yml
kubectl apply -f prometheus/service.yml
kubectl apply -f prometheus/ingress.yml
