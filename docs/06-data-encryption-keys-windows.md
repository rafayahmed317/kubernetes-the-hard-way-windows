# Generating the Data Encryption Config and Key

Kubernetes stores a variety of data including cluster state, application configurations, and secrets. Kubernetes supports the ability to [encrypt](https://kubernetes.io/docs/tasks/administer-cluster/encrypt-data) cluster data at rest.

In this lab you will generate an encryption key and an [encryption config](https://kubernetes.io/docs/tasks/administer-cluster/encrypt-data/#understanding-the-encryption-at-rest-configuration) suitable for encrypting Kubernetes Secrets.

## The Encryption Key

   Generate an encryption key:
   
   ```powershell
   $EncryptionKey = [convert]::ToBase64String((1..32 | ForEach-Object { Get-Random -Minimum 0 -Maximum 256 } | ForEach-Object { [byte]$_ }))
   ```

## The Encryption Config File

   Create the `encryption-config.yaml` encryption config file:
   
   ```powershell
   (Get-Content ".\configs\encryption-config.yaml") -replace "\`${ENCRYPTION_KEY}", $EncryptionKey > encryption-config.yaml
   ```
   
   Copy the `encryption-config.yaml` encryption config file to each controller instance:
   
   ```powershell
   scp encryption-config.yaml "root@cp01.mshome.net:~/"
   ```

Next: [Bootstrapping the etcd Cluster](07-bootstrapping-etcd-windows.md)