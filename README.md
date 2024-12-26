# Kubernetes The Hard Way

This tutorial walks you through setting up Kubernetes the hard way. This guide is not for someone looking for a fully automated tool to bring up a Kubernetes cluster. Kubernetes The Hard Way is optimized for learning, which means taking the long route to ensure you understand each task required to bootstrap a Kubernetes cluster.

> This version specifically focuses on setting up a cluster in a windows environment with tools like PowerShell and Hyper-V.

> The results of this tutorial should not be viewed as production ready, and may receive limited support from the community, but don't let that stop you from learning!

## Copyright

<a rel="license" href="http://creativecommons.org/licenses/by-nc-sa/4.0/"><img alt="Creative Commons License" style="border-width:0" src="https://i.creativecommons.org/l/by-nc-sa/4.0/88x31.png" /></a><br />This work is licensed under a <a rel="license" href="http://creativecommons.org/licenses/by-nc-sa/4.0/">Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License</a>.


## Target Audience

The target audience for this tutorial is someone who wants to understand the fundamentals of Kubernetes and how the core components fit together.

## Cluster Details

Kubernetes The Hard Way guides you through bootstrapping a basic Kubernetes cluster with all control plane components running on a single node, and two worker nodes, which is enough to learn the core concepts.

Component versions:

* [kubernetes](https://github.com/kubernetes/kubernetes) v1.32.0
* [containerd](https://github.com/containerd/containerd) v2.0.1
* [cni](https://github.com/containernetworking/cni) v1.6.1
* [etcd](https://github.com/etcd-io/etcd) v3.5.17

## Labs

This tutorial requires three AMD64 based Hyper-V VMs. There is a guide on how to setup those with least amount of time in the [Prerequisites](docs/01-prerequisites-windows.md) section.

* [Prerequisites](docs/01-prerequisites-windows.md)
* [Setting up the Jumpbox](docs/02-jumpbox-windows.md)
* [Provisioning Compute Resources](docs/03-compute-resources-windows.md)
* [Provisioning the CA and Generating TLS Certificates](docs/04-certificate-authority-windows.md)
* [Generating Kubernetes Configuration Files for Authentication](docs/05-kubernetes-configuration-files-windows.md)
* [Generating the Data Encryption Config and Key](docs/06-data-encryption-keys-windows.md)
* [Bootstrapping the etcd Cluster](docs/07-bootstrapping-etcd-windows.md)
* [Bootstrapping the Kubernetes Control Plane](docs/08-bootstrapping-kubernetes-controllers-windows.md)
* [Bootstrapping the Kubernetes Worker Nodes](docs/09-bootstrapping-kubernetes-workers-windows.md)
* [Configuring kubectl for Remote Access](docs/10-configuring-kubectl-windows.md)
* [Provisioning Pod Network Routes](docs/11-pod-network-routes-windows.md)
* [Smoke Test](docs/12-smoke-test-windows.md)
* [Cleaning Up](docs/13-cleanup-windows.md)
