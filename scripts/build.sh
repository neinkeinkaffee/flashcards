#!/usr/bin/env bash
set -eox pipefail
. ./scripts/lib.sh

LAST_BUILD_COMMIT_HASH=$1

if [[ $(has_diff_since_last_build ./services/backend $LAST_BUILD_COMMIT_HASH) ]]
then build_and_push ./services/backend flashcards-flask
fi

if [[ $(has_diff_since_last_build ./services/frontend $LAST_BUILD_COMMIT_HASH) ]]
then build_and_push ./services/frontend flashcards-nginx
fi
