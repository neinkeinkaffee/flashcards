#!/usr/bin/env bash
set -eox pipefail

. ./scripts/lib.sh

open_port $CI_PORT
copy_to_pi ./kubernetes/secret.yml
exec_on_pi kubectl apply -f secret.yml
exec_on_pi rm secret.yml