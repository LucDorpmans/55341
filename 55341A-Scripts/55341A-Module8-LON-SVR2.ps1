# Module 8 - LON-SVR2
Install-WindowsFeature Failover-Clustering -IncludeManagementTools -IncludeAllSubFeature

# Demo Connect to the iSCSI target

# You could use the following Windows PowerShell cmdlets to manage your iSCSI initiator:
Get-NetFirewallServiceFilter -Service msiscsi | Get-NetFirewallRule | Select DisplayGroup,DisplayName,Enabled

Start-Service msiscsi 
Set-Service msiscsi –StartupType “Automatic” 
New-IscsiTargetPortal –TargetPortalAddress LON-STOR1

Connect-IscsiTarget –NodeAddress "iqn.1991-05.com.microsoft:lon-stor1-lon-svr-vms-target"

Get-Disk | Select DiskNumber, FriendlyName, PartitionStyle, Model, BusType, Size, OperationalStatus | ft
$iSCSIDisks = Get-Disk | Where-Object {  $_.BusType -eq "iSCSI" } 
ForEach ( $iSCSIDisk in $iSCSIDisks ) {
    $DiskNum = $iSCSIDisk.Number
    Get-Disk -Number $DiskNum | Set-Disk -IsOffline $False
    Get-Disk -Number $DiskNum | Initialize-Disk
    Get-Disk -Number $DiskNum | New-Partition -UseMaximumSize
    Get-Disk -Number $DiskNum | Get-Partition | Format-Volume -FileSystem NTFS

}

# $iSCSIDisks = Get-Disk | Where-Object {  $_.BusType -eq "iSCSI" } | Clear-Disk

Test-Cluster -Node LON-SVR1, LON-SVR2
# C:\Users\Administrator.ADATUM\AppData\Local\Temp\Validation Report xxx.htm

New-Cluster -Name Cluster1 -Node LON-SVR1, LON-SVR2 -StaticAddress 172.16.0.125 
    
# Remove-Cluster -Cluster Cluster1 -Force


Add-ClusterFileServerRole -Storage 'Cluster Disk 2' `
    -StaticAddress 172.16.0.130 `
    -Name AdatumFS `
    -Cluster Cluster1

# !
# Set Drive Letter with Failover Cluster Manager...
# !

New-Item -ItemType Directory F:\Shares\Docs
New-SMBShare -Name Docs -Path F:\Shares\Docs -FullAccess "EVERYONE"

Get-SmbShare
Get-SmbShare Docs | FL *

Get-ClusterNode | Select Name, NodeWeight, ID, State
Get-ClusterQuorum | select Cluster, QuorumResource, QuorumType

Add-ClusterNode -Name LON-SVR4 

Get-ClusterNode | Select Name, NodeWeight, ID, State

Remove-ClusterNode -Name LON-SVR4

Get-ClusterQuorum | Select Cluster, QuorumResource, QuorumType

# Create folder and share it on LON-DC1
Set-ClusterQuorum -NodeAndFileShareMajority "\\LON-SVR1\FSW"

# Demo: Set Cluster threshold
Get-Cluster | Format-List *subnet*
(Get-Cluster).SameSubnetThreshold=20

# Demo ClusterLog: 
Get-ClusterLog
PSEdit C:\Windows\Cluster\Reports\Cluster.log

