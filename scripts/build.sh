#!/usr/bin/env bash
set -eox pipefail
. ./scripts/lib.sh

build_and_push ./services/backend flashcards-flask
build_and_push ./services/frontend flashcards-nginx


