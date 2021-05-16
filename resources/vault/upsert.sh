#!/bin/bash
SCOPE=$2
CLUSTER=$1
ENV=$3
VERSION=$4
OCTOKEN=$5
OCCLUSTER=$6
PROJECT=startx-vault
VAULT_RELEASE=0.7.0
DIR=`dirname $(readlink -f $0)`
DIR="$DIR/_console/okd-cluster-resources/vault"
ACTION="install"
ACTIONNAME="Installation de vault (helm)"


function testProjectExist {
    oc project $1 --token=$OCTOKEN --cluster=$OCCLUSTER &>/dev/null
    if [[ $? -gt "0" ]]
    then
        echo -e "Attente de la creation du project $1 pendant 10sec..."
        sleep 10
        testProjectExist $1
    fi
}


testProjectExist $PROJECT
PODCNT=`oc get po -l app.kubernetes.io/name=vault-agent-injector --token=$OCTOKEN --cluster=$OCCLUSTER | wc -l`
if [[ $PODCNT -gt "0" ]]
then
    PODSTATE=`oc get po -l app.kubernetes.io/name=vault-agent-injector -o=jsonpath="{.items[0].status.phase}" --token=$OCTOKEN --cluster=$OCCLUSTER`
    if [[ $PODSTATE == "Running" ]]
    then
        ACTION="upgrade"
        ACTIONNAME="Mise a jour de vault (helm)"
    fi
fi
echo -e "Ajout des SCC pour les SA vault et vault-agent-injector"
oc adm policy add-scc-to-user privileged system:serviceaccount:$PROJECT:vault --token=$OCTOKEN --cluster=$OCCLUSTER
oc adm policy add-scc-to-user privileged system:serviceaccount:$PROJECT:vault-agent-injector --token=$OCTOKEN --cluster=$OCCLUSTER


echo -e "Attente du demarrage de vault"
oc wait po -l app.kubernetes.io/name=vault --for=condition=Ready --timeout=2000ms -n $PROJECT --token=$OCTOKEN --cluster=$OCCLUSTER &>/dev/null
if [[ $? == "0" ]]
then
    echo -e "Attente de l'initialisation de vault"
    sleep 10
    echo -e "Integration de vault avec kubernetes"
    oc cp -n $PROJECT --token=$OCTOKEN --cluster=$OCCLUSTER $DIR/config-k8s.sh $PROJECT/vault-0:/tmp/config-k8s.sh
    oc exec -n $PROJECT --token=$OCTOKEN --cluster=$OCCLUSTER -t vault-0 -- sh /tmp/config-k8s.sh
fi
