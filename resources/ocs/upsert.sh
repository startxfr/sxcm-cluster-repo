#!/bin/bash

SCOPE=$2
CLUSTER=$1
ENV=$3
VERSION=$4
OCTOKEN=$5
OCCLUSTER=$6
LIST=$(oc get node -o name  -l node-role.kubernetes.io/worker --token=$OCTOKEN --cluster=$OCCLUSTER 2>/dev/null)
COUNT=$(echo $LIST | wc -w)
echo -e "Found $COUNT worker node to label as storage node"
if [[ $COUNT -gt 0 ]]; then
    for node in $LIST
    do
        oc label $node cluster.ocs.openshift.io/openshift-storage="" --overwrite --token=$OCTOKEN --cluster=$OCCLUSTER
    done
fi