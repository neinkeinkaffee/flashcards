#!/usr/bin/env bash
set -eox pipefail
. ./scripts/lib.sh

COMMIT_HASH=latest
if [[ $(has_diff_since_last_build ./services $LAST_BUILD_COMMIT_HASH) ]]
then
  COMMIT_HASH=$CIRCLE_SHA1
fi
terraform_apply $COMMIT_HASH
kubectl_exec postgres createdb -U postgres flashcards || true
kubectl_exec flask python3 manage.py recreate_db
kubectl_exec flask python3 manage.py seed_db
