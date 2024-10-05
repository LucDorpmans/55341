# 55341
#Module 8 - LON-STOR1

# Use the following Windows PowerShell cmdlets to manage the iSCSI Target Server:
# Install the iSCSI Target Server feature:
Install-WindowsFeature File-Services,FS-iSCSITarget-Server -IncludeManagementTools

#Create two iSCSI virtual disks and an iSCSI target
New-IscsiVirtualDisk E:\iSCSIVirtualDisks\iSCSIDisk.vhdx –size 50GB 
New-IscsiVirtualDisk E:\iSCSIVirtualDisks\CusterVMsDisk.vhdx –size 50GB 
New-IscsiVirtualDisk E:\iSCSIVirtualDisks\QuorumDisk.vhdx –size 5GB 


New-IscsiServerTarget -TargetName lon-hv-hosts –InitiatorIds "IPAddress:172.16.0.101","IPAddress:172.16.0.102" # ,"IPAddress:172.16.0.23"
Get-IscsiServerTarget | Select-Object TargetName, InitiatorIds
Get-IscsiServerTarget | Select-Object -ExpandProperty InitiatorIds
Remove-IscsiServerTarget -TargetName LON-hv-hosts 

New-IscsiServerTarget -TargetName LON-hv-hosts `
    –InitiatorIds @( "Iqn:iqn.1991-05.com.microsoft:lon-svr1.adatum.com", 
                     "Iqn:iqn.1991-05.com.microsoft:lon-svr2.adatum.com" )

Add-IscsiVirtualDiskTargetMapping -TargetName LON-hv-hosts E:\iSCSIVirtualDisks\iSCSIDisk.vhdx
Add-IscsiVirtualDiskTargetMapping -TargetName lon-hv-hosts E:\iSCSIVirtualDisks\CusterVMsDisk.vhdx
Add-IscsiVirtualDiskTargetMapping -TargetName LON-hv-hosts E:\iSCSIVirtualDisks\QuorumDisk.vhdx

# To add iSNS Initiator(s) to an iSCSI Target:
Get-IscsiServerTarget -TargetName LON-hv-hosts | Set-IscsiServerTarget -InitiatorIds "IPAddress:172.16.0.101","IPAddress:172.16.0.102"
<# Get-IscsiServerTarget -TargetName LON-hv-hosts | Set-IscsiServerTarget `
    –InitiatorIds @( "Iqn:iqn.1991-05.com.microsoft:lon-svr2.adatum.com", 
                     "Iqn:iqn.1991-05.com.microsoft:lon-svr3.adatum.com",
                     "Iqn:iqn.1991-05.com.microsoft:lon-svr4.adatum.com" )
#>
####

New-Item -ItemType Directory C:\FSW
New-SMBShare -Name FSW `
    -Path C:\FSW `
    -FolderEnumerationMode AccessBased `
    -FullAccess "Everyone"


Install-WindowsFeature -Name RSAT-Clustering

# Lab B: Demo Storage Replica
New-Item -ItemType Directory -Path C:\Temp

Install-WindowsFeature Storage-Replica

Restart-Computer

Test-SRTopology