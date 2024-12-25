# Install Flannel
### Setting up the cluster for installing Flannel:
Before we setup flannel, we will have to manually patch the node object in kubernetes for both nodes to add their respective podCIDR ranges. For that you need to have the $machines variable from 03-compute-resources-windows.md, if not, follow the instructions there to create it. Make sure to use the values which you have used previously while configuring the nodes. Then run these commands on the `jumphost`:

```powershell
kubectl patch node/worker-01 -p "{`"spec`":{`"podCIDR`":`"$($Machines.'worker-01'.PodSubnet)`"}}"
```

and for the second node:

```powershell
kubectl patch node/worker-02 -p "{`"spec`":{`"podCIDR`":`"$($Machines.'worker-02'.PodSubnet)`"}}"
```

Also if the worker nodes are running Ubuntu Server, they might not have the br_netfilter module loaded which is requried by flannel, so add it to the modules-load.d directory and manually load it for this time:

```powershell
ssh root@worker-01.mshome.net 'echo "br_netfilter" > /etc/modules-load.d/br_netfilter.conf; modprobe br_netfilter'
ssh root@worker-02.mshome.net 'echo "br_netfilter" > /etc/modules-load.d/br_netfilter.conf; modprobe br_netfilter'
```

### Download, modify and apply kube-flannel.yaml

Then download the yaml manifest for flannel, edit the CIDR in net-conf.json key in kube-flannel-cfg config map in the manifest to cover the node CIDRs you previously assigned, for example if worker-01 has the CIDR 10.200.0.0/24 and worker-02 has the CIDR 10.200.1.0/24, then you should set the CIDR to be 10.200.0.0/16:

```powershell
iwr https://github.com/flannel-io/flannel/releases/latest/download/kube-flannel.yml -Outfile "kube-flannel.yml"
(Get-Content .\kube-flannel.yml) -creplace '"Network":.+"(\d+\.\d+\.\d+\.\d+\/\d+)"','"Network": "10.200.0.0/16"' | Set-Content ".\kube-flannel.yml"
kubectl apply -f ".\kube-flannel.yml"
```

After you run the above, a new namespace kube-flannel will be created and the daemon-set for flannel will be created in that namespace.

### Verification

```powershell
kubectl run pod1 --image busybox --overrides='{"apiVersion": "v1", "spec": {"nodeSelector": { "kubernetes.io/hostname": "worker-01" }}}' --restart Never --command -- sleep 60
kubectl wait --for=condition=Ready pod/pod1 --timeout=30s
kubectl run pod2 --image busybox --overrides='{"apiVersion": "v1", "spec": {"nodeSelector": { "kubernetes.io/hostname": "worker-02" }}}' --attach --rm --command -- "/bin/ping" -c 4 $(kubectl get pod/pod1 -o jsonpath='{.status.podIPs[0].ip}')
kubectl delete pod/pod1
```

Expected result:
```text
If you don't see a command prompt, try pressing enter.
64 bytes from 10.200.0.10: seq=2 ttl=62 time=0.504 ms
64 bytes from 10.200.0.10: seq=3 ttl=62 time=0.664 ms

--- 10.200.0.10 ping statistics ---
4 packets transmitted, 4 packets received, 0% packet loss
round-trip min/avg/max = 0.493/0.617/0.809 ms
pod "pod2" deleted
```