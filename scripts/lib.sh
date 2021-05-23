#!/usr/bin/env bash

function exec_on_pi() {
    ssh -t -o "StrictHostKeyChecking no" $PROXY_USER@$PROXY_HOST ssh $DEPLOY_USER@$DEPLOY_HOST "$@"
}

function copy_to_pi() {
    local FILE=$1
    scp -o ProxyCommand="ssh -W %h:%p $PROXY_USER@$PROXY_HOST" -o "StrictHostKeyChecking no" $FILE $DEPLOY_USER@$DEPLOY_HOST:$DEPLOY_DIR
}

# Credits go to https://advancedweb.hu/2019/04/02/sg_allow_ip/
function open_port() {
    local PORT=$1

    echo "Find the ID of the EC2 instance's security group"
    local SG=$(aws ec2 describe-instances --filter "Name=tag:Name,Values=proxy" \
    --query "Reservations[].Instances[].SecurityGroups[].GroupId" \
    --no-paginate | jq -r '.[0]')

    # Find the public IP of this machine
    while : ; do
        local MYIP=$(curl -s ifconfig.me)
        [ -z "$MYIP" ] || break
    done

    echo "Allow access for public IP of this machine"
    aws ec2 authorize-security-group-ingress --group-id $SG --protocol tcp --port $PORT --cidr "$MYIP/32"
}

function close_port() {
    local PORT=$1

    echo "Find the ID of the EC2 instance's security group"
    local SG=$(aws ec2 describe-instances --filter "Name=tag:Name,Values=proxy" \
    --query "Reservations[].Instances[].SecurityGroups[].GroupId" \
    --no-paginate | jq -r '.[0]')

    echo "Find currently allowed IP ranges"
    local CIDRS=$(aws ec2 describe-security-groups --group-ids $SG \
        | jq -r --argjson PORT "$PORT" '.SecurityGroups[].IpPermissions[]
        | select(.FromPort == $PORT and .ToPort == $PORT and .IpProtocol == "tcp") | .IpRanges[].CidrIp')

    echo "Revoke access for currently allowed IP ranges"
    for ip in $CIDRS; do
        aws ec2 revoke-security-group-ingress --group-id $SG --protocol tcp --port $PORT --cidr $ip
    done
}

function grep_pod_id() {
    local POD_NAME=$1
    local POD_ID=$(exec_on_pi sudo kubectl get pods | grep -o $POD_NAME-[-0-9a-z]*)
    echo $POD_ID
}

function kubectl_apply() {
    for FILE in "$@"
    do
        exec_on_pi sudo kubectl get pods
        copy_to_pi ./kubernetes/$FILE
        exec_on_pi sudo kubectl apply -f $FILE
        exec_on_pi rm $FILE
    done
}

function kubectl_delete_pod() {
    local POD_NAME=$1
    local POD_ID=$(grep_pod_id $POD_NAME)
    exec_on_pi sudo kubectl delete pod $POD_ID
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
    exec_on_pi sudo kubectl exec $POD_ID --stdin -- $COMMAND
}

function git_diff() {
  local SUBDIR=$1
  local COMMIT_HASH=$2
  local GIT_DIFF=$(git diff $COMMIT_HASH $SUBDIR)
  echo $GIT_DIFF
}

function terraform_apply() {
  COMMIT_HASH=$1
  cd terraform
  echo $KUBECONFIG | base64 -d > kubeconfig
  terraform init
  KUBE_CONFIG_PATH=kubeconfig terraform apply -y -var="commit_sha=${COMMIT_HASH}"
  cd ..
}
