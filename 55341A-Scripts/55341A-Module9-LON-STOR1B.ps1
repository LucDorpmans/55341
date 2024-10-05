# 55341
#Module 8 - LON-STOR1

# Use the following Windows PowerShell cmdlets to manage the iSCSI Target Server:
# Install the iSCSI Target Server feature:
Install-WindowsFeature File-Services,FS-iSCSITarget-Server -IncludeManagementTools

#Create two iSCSI virtual disks and an iSCSI target
New-IscsiVirtualDisk E:\iSCSIVirtualDisks\iSCSIDisk1.vhdx –size 50GB 
New-IscsiVirtualDisk E:\iSCSIVirtualDisks\iSCSIDisk2.vhdx –size 5GB 
New-IscsiVirtualDisk E:\iSCSIVirtualDisks\iSCSIDisk3.vhdx –size 55GB 

New-IscsiServerTarget -TargetName lon-svr1 –InitiatorIds "IPAddress:172.16.0.21","IPAddress:172.16.0.22" # ,"IPAddress:172.16.0.23"
Get-IscsiServerTarget | Select-Object TargetName, InitiatorIds
Get-IscsiServerTarget | Select-Object -ExpandProperty InitiatorIds
Remove-IscsiServerTarget -TargetName lon-svr1 

New-IscsiServerTarget -TargetName lon-svr1 `
    –InitiatorIds @( "Iqn:iqn.1991-05.com.microsoft:lon-svr1.adatum.com", 
                     "Iqn:iqn.1991-05.com.microsoft:lon-svr2.adatum.com" )

Add-IscsiVirtualDiskTargetMapping -TargetName lon-svr1 E:\iSCSIVirtualDisks\iSCSIDisk1.vhdx
Add-IscsiVirtualDiskTargetMapping -TargetName lon-svr1 E:\iSCSIVirtualDisks\iSCSIDisk2.vhdx
Add-IscsiVirtualDiskTargetMapping -TargetName lon-svr1 E:\iSCSIVirtualDisks\iSCSIDisk3.vhdx

# To add iSNS Initiator(s) to an iSCSI Target:
Get-IscsiServerTarget -TargetName LON-Svr1 | Set-IscsiServerTarget -InitiatorIds "Iqn:iqn.1991-05.com.microsoft:lon-svr3.adatum.com"
Get-IscsiServerTarget -TargetName LON-Svr1 | Set-IscsiServerTarget `
    –InitiatorIds @( "Iqn:iqn.1991-05.com.microsoft:lon-svr2.adatum.com", 
                     "Iqn:iqn.1991-05.com.microsoft:lon-svr3.adatum.com",
                     "Iqn:iqn.1991-05.com.microsoft:lon-svr4.adatum.com" )

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