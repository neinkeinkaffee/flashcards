#!/usr/bin/env bash
set -eox pipefail

. ./scripts/lib.sh
open_port $CI_PORT
kubectl_apply secret.yml
kubectl_apply flask-deployment.yml flask-service.yml
close_port $CI_PORT
