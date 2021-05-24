#!/usr/bin/env bash
set -eox pipefail
. ./scripts/lib.sh

kubectl_exec postgres createdb -U postgres flashcards || true
kubectl_exec flask python3 manage.py recreate_db
kubectl_exec flask python3 manage.py seed_db
