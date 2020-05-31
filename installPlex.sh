#!/bin/bash

set -e

microk8s kubectl create -f plex/persistent-volume.yml
microk8s kubectl create -f plex/persistent-volume-claim.yml
microk8s kubectl create -f plex/deployment.yml
microk8s kubectl create -f plex/service.yml
microk8s kubectl create -f plex/ingress.yml