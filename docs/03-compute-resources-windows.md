# Provisioning Compute Resources
If you followed the previos instructions and used the Hyper-V script for the creation of VMs and the Default Switch as the network interface for the VMs, you will not have to do much here.

### Machine database:

   Run the following code to create a hashmap containing the neccessary data for each machine. Remember to change the values in this :
   ```powershell
   $cp01 = @{IP=$(Resolve-DnsName "cp01.mshome.net" | Select -First 1 -ExpandProperty IPAddress);DNS="cp01.mshome.net";Hostname="cp01";PodSubnet=$null}
   $worker1 = @{IP=$(Resolve-DnsName "worker-01.mshome.net" | Select -First 1 -ExpandProperty IPAddress);DNS="worker-01.mshome.net";Hostname="worker-01";PodSubnet="10.200.0.0/24"}
   $worker2 = @{IP=$(Resolve-DnsName "worker-02.mshome.net" | Select -First 1 -ExpandProperty IPAddress);DNS="worker-02.mshome.net";Hostname="worker-02";PodSubnet="10.200.1.0/24"}
   $Machines = @{"cp01"=$cp01; "worker-01"=$worker1; "worker-02"=$worker2}
   ```

### Verify SSH connectivity:

   Verify that you can SSH into all the machines:
   ```
   ssh root@cp01.mshome.net echo
   ssh root@worker-01.mshome.net echo
   ssh root@worker-02.mshome.net echo
   ```