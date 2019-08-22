#!/usr/bin/env bash
set -eox pipefail
. ./scripts/lib.sh

build_and_push ./services/server flashcards-flask
build_and_push ./services/client flashcards-nginx

