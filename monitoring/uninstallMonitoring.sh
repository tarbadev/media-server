#!/bin/bash

set -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
kubectl delete -f "$DIR/prometheus"
kubectl delete -f "$DIR/grafana"
kubectl delete -f "$DIR/kube-state-metrics"