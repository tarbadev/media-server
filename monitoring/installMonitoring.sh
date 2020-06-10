#!/bin/bash

set -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
kubectl apply -R -f "$DIR/prometheus"
kubectl apply -R -f "$DIR/grafana"
kubectl apply -R -f "$DIR/kube-state-metrics"
