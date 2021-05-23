#!/usr/bin/env bash
set -eox pipefail
. ./scripts/lib.sh

COMMIT_HASH=$1

terraform_apply $COMMIT_HASH
kubectl_exec postgres createdb -U postgres flashcards || true
kubectl_exec flask python3 manage.py recreate_db
kubectl_exec flask python3 manage.py seed_db
