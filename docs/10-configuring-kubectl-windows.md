# Configuring kubectl for Remote Access

In this lab you will generate a kubeconfig file for the `kubectl` command line utility based on the `admin` user credentials.

> Run the commands in this lab from the `jumpbox` machine.

## The Admin Kubernetes Configuration File

Each kubeconfig requires a Kubernetes API Server to connect to.

You should be able to ping `cp01.mshome.net` if you used the defult Hyper-V switch, and if not, you should be able to ping the network address you chose for your master node.

```powershell
iwr https://cp01.mshome.net:6443/version -SkipCertificateCheck
```

```text
{
  "major": "1",
  "minor": "32",
  "gitVersion": "v1.32.0",
  "gitCommit": "70d3cc986aa8221cd1dfb1121852688902d3bf53",
  "gitTreeState": "clean",
  "buildDate": "2024-12-11T17:59:15Z",
  "goVersion": "go1.23.3",
  "compiler": "gc",
  "platform": "linux/amd64"
}
```

Generate a kubeconfig file suitable for authenticating as the `admin` user:

```powershell
    kubectl config set-cluster kubernetes-the-hard-way --certificate-authority=ca.crt --embed-certs=true --server=https://cp01.mshome.net:6443
  
    kubectl config set-credentials admin --client-certificate=admin.crt --client-key=admin.key
  
    kubectl config set-context kubernetes-the-hard-way --cluster=kubernetes-the-hard-way --user=admin
  
    kubectl config use-context kubernetes-the-hard-way
```
The results of running the command above should create a kubeconfig file in the default location `~/.kube/config` used by the  `kubectl` commandline tool. This also means you can run the `kubectl` command without specifying a config.


## Verification

Check the version of the remote Kubernetes cluster:

```bash
kubectl version
```

```text
Client Version: v1.32.0
Kustomize Version: v5.5.0
Server Version: v1.32.0
```

List the nodes in the remote Kubernetes cluster:

```bash
kubectl get nodes
```

```
NAME        STATUS   ROLES    AGE   VERSION
worker-01   Ready    <none>   11m   v1.32.0
worker-02   Ready    <none>   11m   v1.32.0
```

Next: [Provisioning Pod Network Routes](11-pod-network-routes-windows.md)