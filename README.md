# sxcm cluster-repo examples

![sxcm](https://img.shields.io/badge/latest-v0.1.4-blue.svg) [![last commit](https://img.shields.io/github/last-commit/startxfr/sxcm.svg)](https://github.com/startxfr/sxcm) [![Doc](https://readthedocs.org/projects/sxcm/badge)](https://sxcm.readthedocs.io)

This repositoy is an example of a [sxcm](https://sxcm.readthedocs.io) [gitops repository](https://sxcm.readthedocs.io#gitops-repository) to store [cluster instance](https://sxcm.readthedocs.io#cluster-instance) configuration and state. The `mycluster` [cluster instance](https://sxcm.readthedocs.io#cluster-instance) in this repository is a perfect example of a [sxcm](https://sxcm.readthedocs.io) [gitops repository](https://sxcm.readthedocs.io#gitops-repository).

STARTX [sxcm command](https://sxcm.readthedocs.io) use [gitops repository](https://sxcm.readthedocs.io#gitops-repository) to store cluster configuration and state for this cluster. This [sxcm gitops repository](https://sxcm.readthedocs.io#gitops-repository) could be a [forked](https://github.com/startxfr/sxcm-cluster-repo)and serve as a template of your own [cluster instance](https://sxcm.readthedocs.io#cluster-instance) by using `sxcm import mycluster git@github.com:startxfr/sxcm-cluster-repo.git mycluster`.

For more informations and how to install sxcm, you can visit the [startx sxcm documentation](https://sxcm.readthedocs.io).

