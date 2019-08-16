#!/usr/bin/env bash

function exec_on_pi() {
    ssh -t -o "StrictHostKeyChecking no" $PROXY_USER@$PROXY_HOST ssh $DEPLOY_USER@$DEPLOY_HOST "$@"
}

function copy_to_pi() {
    local FILE=$1
    scp -o ProxyCommand="ssh -W %h:%p $PROXY_USER@$PROXY_HOST" -o "StrictHostKeyChecking no" $FILE $DEPLOY_USER@$DEPLOY_HOST:$DEPLOY_DIR
}

function kubectl_apply() {
    open_port $CI_PORT
    for FILE in "$@"
    do
        exec_on_pi kubectl get pods
        copy_to_pi ./kubernetes/$FILE
        exec_on_pi kubectl apply -f $FILE
        exec_on_pi rm $FILE
    done
    close_port $CI_PORT
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

    # Allow access for public IP of this machine
    [ -z $(echo "$CIDRS" | grep "$MYIP/32") ] && aws ec2 authorize-security-group-ingress \
        --group-id $SG --protocol tcp --port $PORT --cidr "$MYIP/32"
}

function close_port() {
    local PORT=$1

    # Find the ID of the EC2 instance's security group
    local SG=$(aws ec2 describe-instances --filter "Name=tag:Name,Values=proxy" \
    --query "Reservations[].Instances[].SecurityGroups[].GroupId" \
    --no-paginate | jq -r '.[0]')

    # Find currently allowed IP ranges (variable interpolation in jq isn't working as documented)
    local CIDRS=$(aws ec2 describe-security-groups --group-ids $SG \
        | jq -r '.SecurityGroups[].IpPermissions[]
        | select(.FromPort == env.PORT and .ToPort == env.PORT and .IpProtocol == "tcp") | .IpRanges[].CidrIp')

    # Revoke access for currently allowed IP ranges
    for ip in $CIDRS; do
        [ "$MYIP/32" != "$ip" ] && aws ec2 revoke-security-group-ingress \
            --group-id $SG --protocol tcp --port $PORT --cidr $ip
    done
}