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
DIR="$DIR/_console/okd-cluster-resources/argod-deploy"
SERVER_NAME="$ARGOCDPREFIX-server"
DELAY="60"


function checkAllComponents {
    local SERVICE="$1"
    local PROJECT="$2"
    local ERROR="no"
    checkOneComponent "$SERVICE-server" $PROJECT
    if [[ $? == "1" ]]; then ERROR="yes"; fi
    checkOneComponent "$SERVICE-repo-server" $PROJECT
    if [[ $? == "1" ]]; then ERROR="yes"; fi
    # checkOneComponent "$SERVICE-redis-ha" $PROJECT
    # if [[ $? == "1" ]]; then ERROR="yes"; fi
    # checkOneComponent "$SERVICE-redis-ha-haproxy" $PROJECT
    # if [[ $? == "1" ]]; then ERROR="yes"; fi
    checkOneComponent "$SERVICE-dex-server" $PROJECT
    if [[ $? == "1" ]]; then ERROR="yes"; fi
    checkOneComponent "$SERVICE-application-controller" $PROJECT
    if [[ $? == "1" ]]; then ERROR="yes"; fi
    if [[ $ERROR == "yes" ]]; then return 1; fi
    return 0;
}


function checkOneComponent {
    local COMPONENT="$1"
    local PROJECT="$2"
    oc wait po -l app.kubernetes.io/name=$COMPONENT --for=condition=Ready --timeout=2000ms -n $PROJECT --token=$OCTOKEN --cluster=$OCCLUSTER &>/dev/null
    if [[ $? == "0" ]]
    then
        echo -e " - Pod $COMPONENT is running"
        return 0;
    else
        echo -e " - Pod $COMPONENT is not started (Fatal)"
        return 1;
    fi
}

# Start test process
checkOneComponent "$SERVER_NAME" "$PROJECT"
if [[ $? == "0" ]]
then
    echo -e "Pod $SERVER_NAME in $PROJECT is started"
    checkAllComponents "$ARGOCDPREFIX" "$PROJECT"
    if [[ "$?" == "0" ]]
    then
        echo -e "All $ARGOCDPREFIX ArgoCD components are running, continue process..."
    else
        echo -e "Some $ARGOCDPREFIX ArgoCD components are not-running, Wait ${DELAY}s..."
        echo -e "$(echo ${DELAY}/2 | bc)sec left..."
        sleep $(echo ${DELAY}/2 | bc)
        echo -e "Check again if $ARGOCDPREFIX ArgoCD components are running..."
        checkAllComponents "$ARGOCDPREFIX" "$PROJECT"
        if [[ "$?" == "0" ]]
        then
            echo -e "All $ARGOCDPREFIX ArgoCD components are running, continue process..."
        else
            echo -e "Some $ARGOCDPREFIX ArgoCD components are still not-running, Stopping process"
            exit 1;
        fi
    fi
else
    echo -e "Pod $SERVER_NAME in $PROJECT is not present, probably under deployment. Wait ${DELAY}s..."
    echo -e "${DELAY}sec left..."
    sleep ${DELAY}
    checkOneComponent "$SERVER_NAME" "$PROJECT"
    if [[ "$?" == "0" ]]
    then
        echo -e "Pod $SERVER_NAME in $PROJECT is started"
        checkAllComponents "$ARGOCDPREFIX" "$PROJECT"
        if [[ "$?" == "0" ]]
        then
            echo -e "All $ARGOCDPREFIX ArgoCD components are running, continue process..."
        else
            echo -e "Some $ARGOCDPREFIX ArgoCD components are not-running, Wait ${DELAY}s..."
            echo -e "$(echo ${DELAY}/2 | bc)sec left..."
            sleep $(echo ${DELAY}/2 | bc)
            echo -e "Check again if $ARGOCDPREFIX ArgoCD components are running..."
            checkAllComponents "$ARGOCDPREFIX" "$PROJECT"
            if [[ "$?" == "0" ]]
            then
                echo -e "All $ARGOCDPREFIX ArgoCD components are running, continue process..."
            else
                echo -e "Some $ARGOCDPREFIX ArgoCD components are still not-running, Stopping process"
                exit 1;
            fi
        fi
    fi
fi
