#!/bin/bash

set -e

kubectl delete -n=monitoring configmap prometheus-config
kubectl delete -f prometheus/deployment.yml
kubectl delete -f prometheus/service.yml
kubectl delete -f prometheus/ingress.yml