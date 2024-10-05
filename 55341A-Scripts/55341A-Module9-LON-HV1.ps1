# 55341A-Module9-LON-HV1
Import-VM -Path 'D:\Export\LON-NVHOST1\Virtual Machines\4D297843-5F6B-4567-8D71-C47F1277BDE9.vmcx'

Set-VMProcessor -VMName LON-NVHOST1 -ExposeVirtualizationExtensions $true
Get-VMNetworkAdapter -VMName LON-NVHOST1 | Set-VMNetworkAdapter -MacAddressSpoofing On
Set-VMMemory LON-NVHOST1 -DynamicMemoryEnabled $false

Start-VM LON-NVHOST1

Enter-PSSession -VMName LON-NVHOST1

Install-WindowsFeature -Name Hyper-V,Hyper-V-Tools,Hyper-V-Powershell -Restart

Install-WindowsFeature -Name Failover-Clustering –IncludeManagementTools –ComputerName LON-HV1
Install-WindowsFeature -Name Failover-Clustering –IncludeManagementTools –ComputerName LON-HV2

New-Cluster -Name VMCluster -Node LON-HV1, LON-HV2 -StaticAddress 172.16.0.126

Get-ClusterQuorum

Add-ClusterSharedVolume -Name "Cluster Disk 1"

Move-VMStorage -VMName LON-NVHOST1 -DestinationStoragePath "C:\ClusterStorage\Volume1\"

Get-VHD  -Path "C:\ClusterStorage\Volume1\Virtual Hard Disks\LON-NVHOST1.vhd" | Select Path, ParentPath

Set-VHD -Path 'C:\ClusterStorage\Volume1\Virtual Hard Disks\LON-NVHOST1.vhd' -ParentPath 'C:\ClusterStorage\Volume1\Virtual Hard Disks\Server2022Base.vhd'



Add-ClusterVirtualMachineRole -VMName LON-NVHOST1 

Import-VM -Path "D:\Export\LON-VM2\Virtual Machines\15A845A6-85A6-4DD1-923A-540B45F3AA41.vmcx"
Move-VMStorage -VMName LON-VM2 -DestinationStoragePath C:\ClusterStorage\Volume1\ 
Add-ClusterVirtualMachineRole -VMName LON-VM2 
