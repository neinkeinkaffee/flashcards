#!/usr/bin/env bash
set -eox pipefail

. ./scripts/lib.sh

function kubectl_apply() {
    TEMPLATE_FILE=$1
    open_port $CI_PORT
    copy_to_pi ./kubernetes/$TEMPLATE_FILE
    exec_on_pi kubectl apply -f $TEMPLATE_FILE
    exec_on_pi rm $TEMPLATE_FILE
}

kubectl_apply secret.yml