# Provisioning a CA and Generating TLS Certificates

In this section, we will provision a PKI infrastructure using OpenSSL to generate a CA authority and create cerficates for the kube-apiserver, kube-proxy, kubelet, kube-scheduler, kube-controller-manager, and the worker nodes.

<!-- ### Generating the ca.conf file:

   First, we will need to generate the ca.conf file for openssl. For that run the ca.ps1 script in the root of the repo. The script just fills in the DNS names and hostnames of the worker nodes and master node. If you haven't populated the $machines variable in your PS session yet, follow the instructions in 03-compute-resources.md to populate it, and then run the following command:

   ```powershell
   ./ca.ps1
   ```

   It will output a ca.conf file which you can then pass to openssl in the next step. -->

### Certificate Authority:
   Like the original tutorial, this repo also contains the ca.conf file for openssl but the hostnames and DNS names for the api-server, node0 and node1 have been replaced with the hostnames and dnsnames used in this tutorial so far. So if you have chosen other hostnames or dns names, please manually replace cp01, worker-01 and worker-02 in the ca.conf file with your own values.

   Run the following commands to generate the key and crt for the ceritificate authority:
   ```powershell
   openssl genrsa -out ca.key 4096
   openssl req -x509 -new -sha512 -noenc -key ca.key -days 3653 -config ca.conf -out ca.crt
   ```

### Generate client and server auth certificates:

   Now we will generate client and server certificates for all the Kubernetes components like kube-scheduler, kube-apiserver, etc...
   ```powershell
   $certs = @(  "admin","worker-01","worker-02","kube-proxy","kube-scheduler","kube-controller-manager","kube-api-server","service-accounts")
   foreach($cert in $certs){
      openssl genrsa -out "$cert.key" 4096
      openssl req -new -key "$cert.key" -sha256 `
       -config "ca.conf" -section $cert `
       -out "$cert.csr"

      openssl x509 -req -days 3653 -in "$cert.csr" `
       -copy_extensions copyall `
       -sha256 -CA "ca.crt" `
       -CAkey "ca.key" `
       -CAcreateserial `
       -out "$cert.crt"
    }
   ```
   View the certificates generated so far:
   ```powershell
   Get-Item "*.crt", "*.key", "*.csr"
   ```
### Distribute the Client and Server certificates:
   
   Copy the generated ca crt and the kubelet cert and keys to the worker nodes:
   ```powershell
   foreach($worker in @(($machines.Values | ? {$_.PodSubnet -ne $null}))){
      $hostname = $worker.hostname
      $dnsname = $worker.dns
      ssh root@$($dnsname) mkdir /var/lib/kubelet/
      scp ca.crt root@$($dnsname):/var/lib/kubelet/
      scp "$hostname.crt" root@$($dnsname):/var/lib/kubelet/kubelet.crt
      scp "$hostname.key" root@$($dnsname):/var/lib/kubelet/kubelet.key
   }
   ```
   Copy the generated ca crt, kube-apiserver crt and service-account crt and their keys to the master node:
   ```powershell
   scp ca.key ca.crt kube-api-server.key kube-api-server.crt service-accounts.key service-accounts.crt root@cp01.mshome.net:~/
   ```

