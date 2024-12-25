# Setting up the Jumpbox

Here we will setup our windows host (jumpbox) by instaling necessary utlities and downloading the kubernetes binaries necessary for functioning.

## Set up the environment:

### Clone the repo:

As the first step, please clone this repo by executing the following command in windows terminal (or PowerShell):

```
git clone https://github.com/rafayahmed317/kubernetes-the-hard-way-windows.git
```

Or if you don't have git installed, first run this to install git:

```
winget install Microsoft.Git
```

Then cd into the repo by running:

```
cd kubernetes-the-hard-way-windows\
```

### Install the necessary utilities on the jumpbox:

Next, run this command to install the necessary utilities on the jumpbox:

```
winget install ShiningLight.OpenSSL.Dev Kubernetes.kubectl
```

Also install OpenSSH client for connecting to the VMs by running the following command in an administrative PowerShell session:

```
Add-WindowsCapability -Name "OpenSSH.Client" -Online
```


### Download the kubernetes binaries:

This repo contains a powershell script to download the latest versions of all the required binaries. Run it in the repo directory using the following command:

```
./downloads.ps1
```

If the script runs without an error, you should have the following binaries in the same directory as the script:

```
kubectl
kubelet
kube-apiserver
kube-proxy
kube-controller-manager
kube-scheduler
crictl
cni-plugins
runc
containerd
etcd
```

Otherwise, if there are any errors or you want a specfic version of any of these binaries, feel free to manually download them.
