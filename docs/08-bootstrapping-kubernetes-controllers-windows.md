# Bootstrapping the Kubernetes Control Plane

In this lab you will bootstrap the Kubernetes control plane. The following components will be installed on the controller machine: Kubernetes API Server, Scheduler, and Controller Manager.

## Prerequisites

Connect to the `jumpbox` and copy Kubernetes binaries and systemd unit files to the `cp01` instance:

```powershell
scp downloads/kube-apiserver downloads/kube-controller-manager downloads/kube-scheduler downloads/kubectl units/kube-apiserver.service units/kube-controller-manager.service units/kube-scheduler.service configs/kube-scheduler.yaml configs/kube-apiserver-to-kubelet.yaml root@cp01.mshome.net:~/
```

The commands in this lab must be run on the controller instance: `cp01`. Login to the controller instance using the `ssh` command. Example:

```powershell
ssh root@cp01.mshome.net
```

## Provision the Kubernetes Control Plane

Create the Kubernetes configuration directory:

```powershell
mkdir -p /etc/kubernetes/config
```

### Install the Kubernetes Controller Binaries

Install the Kubernetes binaries:

```powershell
{
  chmod +x kube-apiserver \
    kube-controller-manager \
    kube-scheduler kubectl
    
  mv kube-apiserver \
    kube-controller-manager \
    kube-scheduler kubectl \
    /usr/local/bin/
}
```

### Configure the Kubernetes API Server

```powershell
{
  mkdir -p /var/lib/kubernetes/

  mv ca.crt ca.key \
    kube-api-server.key kube-api-server.crt \
    service-accounts.key service-accounts.crt \
    encryption-config.yaml \
    /var/lib/kubernetes/
}
```

Create the `kube-apiserver.service` systemd unit file:

```powershell
mv kube-apiserver.service \
  /etc/systemd/system/kube-apiserver.service
```

### Configure the Kubernetes Controller Manager

Move the `kube-controller-manager` kubeconfig into place:

```powershell
mv kube-controller-manager.kubeconfig /var/lib/kubernetes/
```

Create the `kube-controller-manager.service` systemd unit file:

```powershell
mv kube-controller-manager.service /etc/systemd/system/
```

### Configure the Kubernetes Scheduler

Move the `kube-scheduler` kubeconfig into place:

```powershell
mv kube-scheduler.kubeconfig /var/lib/kubernetes/
```

Create the `kube-scheduler.yaml` configuration file:

```powershell
mv kube-scheduler.yaml /etc/kubernetes/config/
```

Create the `kube-scheduler.service` systemd unit file:

```powershell
mv kube-scheduler.service /etc/systemd/system/
```

### Start the Controller Services

```powershell
{
  systemctl daemon-reload
  
  systemctl enable kube-apiserver \
    kube-controller-manager kube-scheduler
    
  systemctl start kube-apiserver \
    kube-controller-manager kube-scheduler
}
```

> Allow up to 10 seconds for the Kubernetes API Server to fully initialize.


### Verification

```powershell
kubectl cluster-info \
  --kubeconfig admin.kubeconfig
```

```text
Kubernetes control plane is running at https://127.0.0.1:6443
```

## RBAC for Kubelet Authorization

In this section you will configure RBAC permissions to allow the Kubernetes API Server to access the Kubelet API on each worker node. Access to the Kubelet API is required for retrieving metrics, logs, and executing commands in pods.

> This tutorial sets the Kubelet `--authorization-mode` flag to `Webhook`. Webhook mode uses the [SubjectAccessReview](https://kubernetes.io/docs/admin/authorization/#checking-api-access) API to determine authorization.

The commands in this section will affect the entire cluster and only need to be run on the controller node.

```powershell
ssh root@cp01.mshome.net
```

Create the `system:kube-apiserver-to-kubelet` [ClusterRole](https://kubernetes.io/docs/admin/authorization/rbac/#role-and-clusterrole) with permissions to access the Kubelet API and perform most common tasks associated with managing pods:

```powershell
kubectl apply -f kube-apiserver-to-kubelet.yaml \
  --kubeconfig admin.kubeconfig
```

### Verification

At this point the Kubernetes control plane is up and running. Run the following commands from the `jumpbox` machine to verify it's working:

Make a HTTP request for the Kubernetes version info:

```powershell
iwr https://cp01.mshome.net:6443/version -SkipCertificateCheck
```

```text
{
  "major": "1",
  "minor": "31",
  "gitVersion": "v1.31.2",
  "gitCommit": "5864a4677267e6adeae276ad85882a8714d69d9d",
  "gitTreeState": "clean",
  "buildDate": "2024-10-22T20:28:14Z",
  "goVersion": "go1.22.8",
  "compiler": "gc",
  "platform": "linux/arm64"
}
```

Next: [Bootstrapping the Kubernetes Worker Nodes](09-bootstrapping-kubernetes-workers-windows.md)