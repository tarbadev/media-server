#!/bin/bash

set -e

microk8s kubectl delete -f plex/ingress.yml
microk8s kubectl delete -f plex/service.yml
microk8s kubectl delete -f plex/deployment.yml
microk8s kubectl delete -f plex/persistent-volume-claim.yml
microk8s kubectl delete -f plex/persistent-volume.yml