#!/bin/bash
SCOPE=$2
CLUSTER=$1
ENV=$3
VERSION=$4
OCTOKEN=$5
OCCLUSTER=$6
ARGOCDPREFIX=startx
PROJECT=startx-argocd
DIR=`dirname $(readlink -f $0)`
DIR="$DIR/_console/okd-cluster-resources/argod-project"
SERVER_NAME="argocd-operator"
DELAY="60"

echo "STOP WORD IN ARGOCD PROJECT DEPLOY !!!!!!!!!!!"
exit


oc wait po -l name=$SERVER_NAME --for=condition=Ready --timeout=500ms -n $PROJECT --token=$OCTOKEN --cluster=$OCCLUSTER &>/dev/null
if [[ $? == "0" ]]
then
    echo -e "Operator $SERVER_NAME in $PROJECT is started"
else
    echo -e "Operator $SERVER_NAME in $PROJECT is not present, probably under deployment. Wait ${DELAY}s..."
    echo -e "${DELAY}sec left..."
    sleep ${DELAY}
    oc wait po -l name=$SERVER_NAME --for=condition=Ready --timeout=${DELAY}0ms -n $PROJECT --token=$OCTOKEN --cluster=$OCCLUSTER &>/dev/null
    if [[ $? == "0" ]]
    then
        echo -e "Operator $SERVER_NAME in $PROJECT is now started"
    else
        oc get po -n $PROJECT --token=$OCTOKEN --cluster=$OCCLUSTER
        echo -e "Operator $SERVER_NAME in $PROJECT is still not ready. Wait ${DELAY}s more..."
        echo -e "$(echo ${DELAY}/2 | bc)sec left..."
        sleep $(echo ${DELAY}/2 | bc)
        oc wait po -l name=$SERVER_NAME --for=condition=Ready --timeout=${DELAY}0ms -n $PROJECT --token=$OCTOKEN --cluster=$OCCLUSTER &>/dev/null
        if [[ $? == "0" ]]
        then
            echo -e "Operator $SERVER_NAME in $PROJECT is started"
        else
            echo -e "Operator $SERVER_NAME in $PROJECT is not started after ${DELAY}s x 2"
            exit 1;
        fi
    fi
    echo -e "Add anyuid SCC to argocd-redis-ha service account in $PROJECT namespace"
    oc adm policy add-scc-to-user anyuid -z argocd-redis-ha -n $PROJECT --token=$OCTOKEN --cluster=$OCCLUSTER &>/dev/null
fi
