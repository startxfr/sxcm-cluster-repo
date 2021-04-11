# sxcm-cluster-repo

Example of a gitops repository to store cluster profile configuration and state
for myClusterName sxcm default example


# Requirements

## sxcm installation

See sxcm documentation to install sxcm.

## sxcm configuration

```
sxcm setup git https://github.com/startxfr/sxcm-cluster-repo-private.git devel
sxcm switch devel
```

# Installation

```
sxcm import devel
sxcm info
```

# Deployement

```
sxcm deploy
sxcm info
```

# Connection

```
sxcm connect
oc get project
oc get nodes
```

# Destruction

```
sxcm destroy
sxcm delete
```

