#!/usr/bin/env bash

function grep_pod_id() {
    local POD_NAME=$1
    local POD_ID=$(KUBECONFIG=kubeconfig kubectl get pods | grep -o $POD_NAME-[-0-9a-z]*)
    echo $POD_ID
}

function copy_qemu_bin {
    local DOCKER_FILE_DIR=$1

    docker run --rm --privileged multiarch/qemu-user-static:register
    if [ ! -f qemu-arm-static ]; then
        wget -N https://github.com/multiarch/qemu-user-static/releases/download/v2.9.1-1/x86_64_qemu-arm-static.tar.gz
        tar -xvf x86_64_qemu-arm-static.tar.gz
    fi
    cp qemu-arm-static $DOCKER_FILE_DIR
}

function build_image() {
    local DOCKER_FILE_DIR=$1
    local APP_NAME=$2
    local COMMIT_HASH=$(git log -1 --pretty=%H)
    local IMAGE_NAME=${DOCKER_HUB_NAMESPACE}/${APP_NAME}

    docker build -t ${IMAGE_NAME}:${COMMIT_HASH} ${DOCKER_FILE_DIR}
    docker tag ${IMAGE_NAME}:${COMMIT_HASH} ${IMAGE_NAME}:latest
}

function push_image() {
    local IMAGE_NAME=$1

    echo $DOCKER_HUB_PASSWORD | base64 --decode | docker login --username $DOCKER_HUB_NAMESPACE --password-stdin
    docker push $DOCKER_HUB_NAMESPACE/${IMAGE_NAME}:${CIRCLE_SHA1}
}

function build_and_push() {
    local DOCKER_FILE_DIR=$1
    local IMAGE_NAME=$2

    copy_qemu_bin $DOCKER_FILE_DIR
    build_image $DOCKER_FILE_DIR $IMAGE_NAME
    push_image $IMAGE_NAME
}

function kubectl_exec() {
    local PARAMS=( ${@//\/ } )
    local POD_NAME=${PARAMS[0]}
    local COMMAND=${PARAMS[@]:1}
    local POD_ID=$(grep_pod_id $POD_NAME)
    KUBECONFIG=kubeconfig kubectl exec $POD_ID --stdin -- $COMMAND
}

function has_diff_since_last_build() {
  local SUBDIR=$1
  local COMMIT_HASH=$2
  local GIT_DIFF=$(git diff $COMMIT_HASH $SUBDIR)
  echo $GIT_DIFF
}

function terraform_apply() {
  COMMIT_HASH=$1
  cd terraform
  echo $KUBECONFIG | base64 -d > kubeconfig
  terraform init -backend-config="bucket=$AWS_STATE_BUCKET" -backend-config="region=$AWS_REGION"
  KUBE_CONFIG_PATH=kubeconfig terraform apply --auto-approve -var="commit_sha=${COMMIT_HASH}"
  cd ..
}
