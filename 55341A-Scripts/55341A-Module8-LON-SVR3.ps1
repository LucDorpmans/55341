# Module 8 - LON-SVR3
# Demo Connect to the iSCSI target

# You could use the following Windows PowerShell cmdlets to manage your iSCSI initiator:
Get-NetFirewallServiceFilter -Service msiscsi | Get-NetFirewallRule | Select DisplayGroup,DisplayName,Enabled

Start-Service msiscsi 
Set-Service msiscsi –StartupType "Automatic" 
New-IscsiTargetPortal –TargetPortalAddress LON-SVR1

Connect-IscsiTarget –NodeAddress "iqn.1991-05.com.microsoft:lon-svr1-lon-svr1-target"

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

New-Cluster -Name Cluster1 -Node LON-SVR2, LON-SVR3 -StaticAddress 172.16.0.125 
    
# Remove-Cluster -Cluster Cluster1 -Force


