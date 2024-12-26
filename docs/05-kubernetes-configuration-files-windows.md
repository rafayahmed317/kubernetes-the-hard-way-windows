# Generating Kubernetes Configuration Files for Authentication

   In this lab you will generate [Kubernetes client configuration files](https://kubernetes.io/docs/concepts/configuration/organize-cluster-access-kubeconfig/), typically called kubeconfigs, which configure Kubernetes clients to connect and authenticate to Kubernetes API Servers.

## Client Authentication Configs

   In this section you will generate kubeconfig files for the `kubelet` and the `admin` user.

### The kubelet Kubernetes Configuration File

   When generating kubeconfig files for Kubelets the client certificate matching the Kubelet's node name must be used. This will ensure Kubelets are properly authorized by the Kubernetes    [Node Authorizer](https://kubernetes.io/docs/admin/authorization/node/).
   
   > The following commands must be run in the same directory used to generate the SSL certificates during the [Generating TLS Certificates](04-certificate-authority-windows.md) lab.
   
   Generate a kubeconfig file for the worker nodes:
   
   ```powershell
   foreach($worker in @(($machines.Values | ? {$_.PodSubnet -ne $null}))){

     $hostname = $worker.hostname
     $dnsname = $worker.dns
   
     kubectl config set-cluster kubernetes-the-hard-way --certificate-authority=ca.crt --embed-certs=true --server=https://cp01.mshome.net:6443 --kubeconfig=$hostname.kubeconfig
   
     kubectl config set-credentials system:node:$hostname --client-certificate=$hostname.crt --client-key=$hostname.key --embed-certs=true --kubeconfig=$hostname.kubeconfig
   
     kubectl config set-context default --cluster=kubernetes-the-hard-way --user=system:node:$hostname --kubeconfig=$hostname.kubeconfig
   
     kubectl config use-context default --kubeconfig=$hostname.kubeconfig
   }
   ```

### The kube-proxy Kubernetes Configuration File

```powershell
  kubectl config set-cluster kubernetes-the-hard-way --certificate-authority=ca.crt --embed-certs=true --server=https://cp01.mshome.net:6443 --kubeconfig=kube-proxy.kubeconfig

  kubectl config set-credentials system:kube-proxy --client-certificate=kube-proxy.crt --client-key=kube-proxy.key --embed-certs=true --kubeconfig=kube-proxy.kubeconfig

  kubectl config set-context default --cluster=kubernetes-the-hard-way --user=system:kube-proxy --kubeconfig=kube-proxy.kubeconfig

  kubectl config use-context default --kubeconfig=kube-proxy.kubeconfig
```

### The kube-controller-manager Kubernetes Configuration File

Generate a kubeconfig file for the `kube-controller-manager` service:

```powershell
  kubectl config set-cluster kubernetes-the-hard-way --certificate-authority=ca.crt --embed-certs=true --server=https://cp01.mshome.net:6443 --kubeconfig=kube-controller-manager.kubeconfig

  kubectl config set-credentials system:kube-controller-manager --client-certificate=kube-controller-manager.crt --client-key=kube-controller-manager.key --embed-certs=true --kubeconfig=kube-controller-manager.kubeconfig

  kubectl config set-context default --cluster=kubernetes-the-hard-way --user=system:kube-controller-manager --kubeconfig=kube-controller-manager.kubeconfig

  kubectl config use-context default --kubeconfig=kube-controller-manager.kubeconfig
```

### The kube-scheduler Kubernetes Configuration File

Generate a kubeconfig file for the `kube-scheduler` service:

```powershell
  kubectl config set-cluster kubernetes-the-hard-way --certificate-authority=ca.crt --embed-certs=true --server=https://cp01.mshome.net:6443 --kubeconfig=kube-scheduler.kubeconfig

  kubectl config set-credentials system:kube-scheduler --client-certificate=kube-scheduler.crt --client-key=kube-scheduler.key --embed-certs=true --kubeconfig=kube-scheduler.kubeconfig

  kubectl config set-context default --cluster=kubernetes-the-hard-way --user=system:kube-scheduler --kubeconfig=kube-scheduler.kubeconfig

  kubectl config use-context default --kubeconfig=kube-scheduler.kubeconfig
```

### The admin Kubernetes Configuration File

Generate a kubeconfig file for the `admin` user:

```powershell
  kubectl config set-cluster kubernetes-the-hard-way --certificate-authority=ca.crt --embed-certs=true --server=https://127.0.0.1:6443 --kubeconfig=admin.kubeconfig

  kubectl config set-credentials admin --client-certificate=admin.crt --client-key=admin.key --embed-certs=true --kubeconfig=admin.kubeconfig

  kubectl config set-context default --cluster=kubernetes-the-hard-way --user=admin --kubeconfig=admin.kubeconfig

  kubectl config use-context default --kubeconfig=admin.kubeconfig
```

## Distribute the Kubernetes Configuration Files

   ```powershell
   foreach($worker in @(($machines.Values | ? {$_.PodSubnet -ne $null}))){
      
      $hostname = $worker.hostname
      
      $dnsname = $worker.dns
        
        ssh root@$dnsname "mkdir /var/lib/{kube-proxy,kubelet}"
        
        scp "kube-proxy.kubeconfig" "root@$($dnsname):/var/lib/kube-proxy/kubeconfig"
        
        scp "$hostname.kubeconfig" "root@$($dnsname):/var/lib/kubelet/kubeconfig"
   
   }
   ```
   Copy the `kube-controller-manager` and `kube-scheduler` kubeconfig files to the controller instance:
   ```powershell
   scp admin.kubeconfig kube-controller-manager.kubeconfig kube-scheduler.kubeconfig root@cp01.mshome.net:~/
   ```