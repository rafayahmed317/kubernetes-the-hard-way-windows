# Prerequisites

You will have to create 3 VMs on Hyper-V that run a debian based operating system, i.e Ubuntu. There is no requirement for a GUI so you can save storage by using Ubuntu server.

Also, it's recommended to setup these VMs using this script (https://github.com/rafayahmed317/hyperv-vm-provisioning) to save time and avoid doing repetitive tasks.

Here are the instructions for setting up three VMs using the provided script:

### Setup VMs:

1. Open an administrative Windows Terminal or PowerShell window.
2. Make sure to install ssh using this command, because we will use the public key for access to our VMs later.

   ```
   Add-WindowsCapability -Name "OpenSSH.Client" -Online
   ```
3. Git clone or download this (https://github.com/rafayahmed317/hyperv-vm-provisioning) repo.
4. Change working directory to the repo:

   ```
   cd hyperv-vm-provisioning
   ```
5. Run the following command to create and provision the control plane node:

   ```powershell
   .\New-HyperVCloudImageVM.ps1 -VMName "cp01" -VMGeneration 2 -VMProcessorCount 2 -VMDynamicMemoryEnabled 1 -VMMemoryStartupBytes 4GB -VHDSizeBytes 30GB -ImageVersion "focal" -VirtualSwitchName "Default Switch" -VMHostname "cp01" -GuestAdminSshPubKeyFile "$env:USERPROFILE\.ssh\id_rsa.pub" -InstallPowershell -AddKeyToRoot -RootPassword "****"
   ```

    Specifying a root password and installing powershell is optional.

6. Similarly setup two worker nodes. Remember to change both the VMName and VMHostname:

   ```powershell
   .\New-HyperVCloudImageVM.ps1 -VMName "worker-01" -VMGeneration 2 -VMProcessorCount 2 -VMDynamicMemoryEnabled 1 -VMMemoryStartupBytes 4GB -VHDSizeBytes 30GB -ImageVersion "focal" -VirtualSwitchName "Default Switch" -VMHostname "worker-01" -GuestAdminSshPubKeyFile "$env:USERPROFILE\.ssh\id_rsa.pub" -InstallPowershell -AddKeyToRoot -RootPassword "****"
   ```

   ```powershell
   .\New-HyperVCloudImageVM.ps1 -VMName "worker-02" -VMGeneration 2 -VMProcessorCount 2 -VMDynamicMemoryEnabled 1 -VMMemoryStartupBytes 4GB -VHDSizeBytes 30GB -ImageVersion "focal" -VirtualSwitchName "Default Switch" -VMHostname "worker-02" -GuestAdminSshPubKeyFile "$env:USERPROFILE\.ssh\id_rsa.pub" -InstallPowershell -AddKeyToRoot -RootPassword "****"
   ```

   Note: It's recommended to use the Default Switch for the VMs because it has a builtin dns server that automatically assigns DNS names to the VMs according to their hostnames, which is good because it removes the use of static ips for everything and solves a lot of connectivity related issues. 

Now if everything went well, you should have three VMs namely cp01, worker-01 and worker-02 running on Hyper-V.
