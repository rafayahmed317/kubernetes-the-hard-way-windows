## First create the downloads directory
New-Item -ItemType Directory -Name "Downloads"

$arch = "amd64" # arm64 # arm 
$platform = "linux"

## Download all the kubernetes binaries like kubelet, kubectl, kube-api-server etc...
$latest_version = curl https://cdn.dl.k8s.io/release/stable.txt
$kubeBinaries = @("kubelet", "kubectl", "kube-apiserver", "kube-proxy", "kube-controller-manager", "kube-scheduler")

foreach($binary in $kubeBinaries){
    Write-Host "Downloading $binary ...."
    Invoke-WebRequest -Method Get -Uri "https://dl.k8s.io/$latest_version/bin/linux/$arch/$binary" -OutFile "./downloads/$binary"
}

## Download additional bninaries necessary for the cluster, like etcd, containerd, runc, etc...

$crictl = ((Invoke-WebRequest https://api.github.com/repos/kubernetes-sigs/cri-tools/releases/latest).Content
            | ConvertFrom-Json).assets | Where-Object {$_.name -like "*crictl*-$platform*-$arch*.tar.gz"} 

$runc = ((Invoke-WebRequest https://api.github.com/repos/opencontainers/runc/releases/latest).Content
| ConvertFrom-Json).assets | Where-Object {$_.name -like "runc.$arch"}

$cniPlugins = ((Invoke-WebRequest "https://api.github.com/repos/containernetworking/plugins/releases").Content
| ConvertFrom-Json).assets | Where-Object {$_.name -like "*cni-plugins*-$platform*-$arch*.tgz"} | Sort-Object -Property created_at -Descending | Select-Object -First 1

$containerd = ((Invoke-WebRequest https://api.github.com/repos/containerd/containerd/releases/latest).Content
| ConvertFrom-Json).assets | Where-Object {$_.name -like "*containerd*-$platform*-$arch*.tar.gz" -and ($_.name -notlike "*static*")}

$etcd = ((Invoke-WebRequest https://api.github.com/repos/etcd-io/etcd/releases/latest).Content
| ConvertFrom-Json).assets | Where-Object {$_.name -like "*etcd*-$platform*-$arch*.tar.gz"}

Write-Host "Downloading crictl ...."
Invoke-WebRequest $crictl.browser_download_url -OutFile "./downloads/"+$crictl.name
Write-Host "Downloading runc ...."
Invoke-WebRequest $runc.browser_download_url -OutFile "./downloads/"+$runc.name
Write-Host "Downloading cni-plugins ...."
Invoke-WebRequest $cniPlugins.browser_download_url -OutFile "./downloads/"+$cniPlugins.name
Write-Host "Downloading containerd ...."
Invoke-WebRequest $containerd.browser_download_url -OutFile "./downloads/"+$containerd.name
Write-Host "Downloading etcd ...."
Invoke-WebRequest $etcd.browser_download_url -OutFile "./downloads/"+$etcd.name