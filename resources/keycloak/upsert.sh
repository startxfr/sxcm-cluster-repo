#!/bin/bash
SCOPE=$2
CLUSTER=$1
ENV=$3
VERSION=$4
OCTOKEN=$5
OCCLUSTER=$6
PROJECT=startx-keycloak
DIR=`dirname $(readlink -f $0)`

echo -e "Autorisation anyuid pour SA freeipa-pod"
oc adm policy add-scc-to-user anyuid system:serviceaccount:$PROJECT:freeipa-pod --token=$OCTOKEN --cluster=$OCCLUSTER
oc adm policy add-scc-to-user hostmount-anyuid system:serviceaccount:$PROJECT:freeipa-pod --token=$OCTOKEN --cluster=$OCCLUSTER