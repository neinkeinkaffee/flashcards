#!/usr/bin/env bash
set -eox pipefail

. ./scripts/lib.sh
#kubectl_apply secret.yml
kubectl_apply flask-deployment.yml flask-service.yml