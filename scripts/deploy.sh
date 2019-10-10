#!/usr/bin/env bash
set -eox pipefail
. ./scripts/lib.sh

open_port $CI_PORT
kubectl_apply persistent-volume-hostpath.yml persistent-volume-claim-hostpath.yml
kubectl_apply secret.yml
kubectl_apply postgres-deployment.yml postgres-service.yml
kubectl_delete_pod flask || kubectl_apply flask-deployment.yml flask-service.yml
kubectl_delete_pod nginx || kubectl_apply nginx-deployment.yml nginx-service.yml
kubectl_exec postgres createdb -U postgres flashcards || true
#kubectl_exec flask python3 manage.py recreate_db
#kubectl_exec flask python3 manage.py seed_db
close_port $CI_PORT
