#!/usr/bin/env bash
set -eox pipefail
. ./scripts/lib.sh

LAST_BUILD=$1

if [[ $(git_diff $LAST_BUILD ./services/backend) ]]
then build_and_push ./services/backend flashcards-flask
fi

if [[ $(git_diff $LAST_BUILD ./services/frontend) ]]
then build_and_push ./services/frontend flashcards-nginx
fi
