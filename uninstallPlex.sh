#!/bin/bash

set -e

kubectl delete -f plex/ingress.yml
kubectl delete -f plex/service.yml
kubectl delete -f plex/deployment.yml
kubectl delete -f plex/persistent-volume-claim.yml
kubectl delete -f plex/persistent-volume.yml