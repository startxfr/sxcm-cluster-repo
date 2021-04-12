# sxcm cluster repository examples

![sxcm](https://img.shields.io/badge/latest-v0.0.4-blue.svg) [![last commit](https://img.shields.io/github/last-commit/startxfr/sxcm-cluster-repo.svg)](https://github.com/startxfr/sxcm) [![Doc](https://readthedocs.org/projects/sxcm-cluster-repo/badge)](https://sxcm-cluster-repo.readthedocs.io)

STARTX sxcm gitops repository to store cluster configuration and state for various cluster examples.
For more informations and how to install sxcm, you can visit the [startx sxcm homepage](https://startxfr.github.io/sxcm) or the [startx sxcm documentation](https://sxcm.readthedocs.io).

## 1. Requirements

You must follow the [sxcm system requirements and install documentation](https://sxcm.readthedocs.io/en/latest/1-requirements/) to get and install the sxcm cli.

## 2. global config

After this basic installation, you can [follow the sxcm configuration guide](https://sxcm.readthedocs.io/en/stable/2-configure/).

```bash
# setup this example repository
sxcm setup git https://github.com/startxfr/sxcm-cluster-repo.git
```

## 3. Cluster creation

### Import existing myClusterName cluster

```bash
# import the undeployed example
sxcm import myClusterName
# display information about the cluster 
sxcm info
# deploy this cluster
sxcm deploy
# connect to this cluster
sxcm connect
# display various cluster informations
oc get project
oc get nodes
```

### Import existing undeployed cluster

```bash
# import the undeployed example
sxcm import undeployed
# display information about the cluster 
sxcm info
# deploy this cluster
sxcm deploy
# connect to this cluster
sxcm connect
# display various cluster informations
oc get project
oc get nodes
```

### Import existing deployed cluster

```bash
# import the deployed example
sxcm import deployed
# display information about the cluster 
sxcm info
# deploy this cluster
sxcm deploy
# connect to this cluster
sxcm connect
# display various cluster informations
oc get project
oc get nodes
```

## 4. Cluster deletion

### Destruction of cluster

```bash
# destruction of the the active cluster
sxcm destroy
```

### Removal of cluster

```bash
# Removal of the the active cluster
sxcm delete
```

## 5. Release lifecycle

If you want to have more information about the sxcm relese lifecycle, you can read the [release lifecycle](https://sxcm.readthedocs.io/en/stable/5-release-lifecycle/).

## 6. Release history

If you want to have more information about the various sxcm release and their content, you can read the [release history](https://sxcm.readthedocs.io/en/stable/6-release-history/).
