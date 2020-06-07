#!/bin/bash

set -e

kubectl apply -f plex/persistent-volume.yml
kubectl apply -f plex/persistent-volume-claim.yml
kubectl apply -f plex/deployment.yml
kubectl apply -f plex/service.yml
kubectl apply -f plex/ingress.yml
