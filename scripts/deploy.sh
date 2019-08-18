#!/usr/bin/env bash
set -eox pipefail
. ./scripts/lib.sh

open_port $CI_PORT
kubectl_apply persistent-volume-hostpath.yml persistent-volume-claim-hostpath.yml
kubectl_apply secret.yml
kubectl_apply postgres-deployment.yml postgres-service.yml
kubectl_apply flask-deployment.yml flask-service.yml
kubectl_apply nginx-deployment.yml nginx-service.yml
close_port $CI_PORT
