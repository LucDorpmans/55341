#Module 3 - LON-DC1

# Install the iSCSI Target Server feature:
Install-WindowsFeature FS-iSCSITarget-Server 

$iSCSIDisksPath = "E:\iSCSIVirtualDisks"

New-IscsiServerTarget -TargetName iSCSI-Target1 –InitiatorIds "IPAddress:10.10.100.21", "IPAddress:10.10.100.22"
New-IscsiServerTarget -TargetName iSCSI-Target2 –InitiatorIds "IPAddress:10.10.100.21", "IPAddress:10.10.100.22"
New-IscsiServerTarget -TargetName iSCSI-Target3 –InitiatorIds "IPAddress:10.10.100.21", "IPAddress:10.10.100.22"

#Create two iSCSI virtual disks and an iSCSI target
New-IscsiVirtualDisk $iSCSIDisksPath\iSCSIDisk1.vhdx –size 11GB 
New-IscsiVirtualDisk $iSCSIDisksPath\iSCSIDisk2.vhdx –size 12GB 
New-IscsiVirtualDisk $iSCSIDisksPath\iSCSIDisk3.vhdx –size 13GB 
New-IscsiVirtualDisk $iSCSIDisksPath\iSCSIDisk4.vhdx –size 14GB 
New-IscsiVirtualDisk $iSCSIDisksPath\iSCSIDisk5.vhdx –size 15GB 
Add-IscsiVirtualDiskTargetMapping -TargetName iSCSI-Target1 $iSCSIDisksPath\iSCSIDisk1.vhdx
Add-IscsiVirtualDiskTargetMapping -TargetName iSCSI-Target1 $iSCSIDisksPath\iSCSIDisk2.vhdx
Add-IscsiVirtualDiskTargetMapping -TargetName iSCSI-Target1 $iSCSIDisksPath\iSCSIDisk3.vhdx
Add-IscsiVirtualDiskTargetMapping -TargetName iSCSI-Target2 $iSCSIDisksPath\iSCSIDisk4.vhdx
Add-IscsiVirtualDiskTargetMapping -TargetName iSCSI-Target3 $iSCSIDisksPath\iSCSIDisk5.vhdx

New-IscsiServerTarget -TargetName iSCSI-Target2 –InitiatorIds "IPAddress:10.10.100.3", 

Get-IscsiServerTarget | Select TargetName, InitiatorIds
Remove-IscsiServerTarget -TargetName iSCSI-Target2 

New-IscsiServerTarget -TargetName iSCSI-Target1 –InitiatorIds "IPAddress:10.10.100.3"

# To add 1 iSNS Initiator(s) to an iSCSI Target:
Get-IscsiServerTarget -TargetName iSCSI-Target3 | Set-IscsiServerTarget -InitiatorIds "Iqn:iqn.1991-05.com.microsoft:lon-svr3.adatum.com"

# To add multiple iSNS Initiator(s) to an iSCSI Target:
Get-IscsiServerTarget -TargetName iSCSI-Target1 | 
    Set-IscsiServerTarget –InitiatorIds @(  "IPAddress:10.10.100.21", 
                                            "IPAddress:192.168.222.21"  )


# To add an iSNS Initiator to an existin list of initiators:
(Get-IscsiServerTarget -TargetName iSCSI-Target1).InitiatorIds
$CurrInits = (Get-IscsiServerTarget -TargetName iSCSI-Target3).InitiatorIds
$AddInit = New-Object  -TypeName Microsoft.Iscsi.Target.Commands.InitiatorId ("Iqn:iqn.1991-05.com.microsoft:lon-svr3.adatum.com")
$NewInits = $CurrInits + $AddInit
Get-IscsiServerTarget -TargetName iSCSI-Target3 | Set-IscsiServerTarget –InitiatorIds $NewInits
(Get-IscsiServerTarget -TargetName iSCSI-Target3).InitiatorIds

#Demo MPIO
Add-WindowsFeature MultiPath-IO -IncludeManagementTools -IncludeAllSubFeature
# Restart-Computer
Get-MPIOAvailableHW 
Enable-MSDSMAutomaticClaim -BusType iSCSI 
Get-MSDSMGlobalDefaultLoadBalancePolicy
Set-MSDSMGlobalDefaultLoadBalancePolicy -Policy RR 
Set-MPIOSetting -NewDiskTimeout 60 

#region iSNS
# To add an iSNS server, use the following command:
Add-WindowsFeature iSNS

# Enabling inbound traffic on a server running iSNS Server:
# netsh advfirewall firewall> set rule "iSNS Server (TCP In)" new enable=yes
New-NetFirewallRule -Name iSNS-TCP-In -DisplayName “Allow iSCSI Service (TCP-In)”`  -Description “iSCSI Service (TCP-In)”  -Enabled True -Profile Any -Action Allow 

# To configure iSCSI Targets to register with an iSNS Server:
Set-WmiInstance -Namespace root\wmi -Class WT_iSNSServer -Arguments @{ServerName="LON-DC1"}

#To view iSNS server settings, use the following command:
Get-WmiObject -Namespace root\wmi -Class WT_iSNSServer 

#To delete an iSNS server, use the following command:
Get-WmiObject -Namespace root\wmi -Class WT_iSNSServer -Filter "ServerName =’LON-DC1’ | Remove-WmiInstance "

# To list the currently set iSNS Servers:
Get-WmiObject `
  -Class MSiSCSIInitiator_iSNSServerClass `
  -Namespace root\wmi
#endregion

#On LON-DC1 do:
New-SmbMapping -LocalPath Z: -RemotePath \\172.16.0.21\DemoShare2
Get-ChildItem Z:\
New-Item "Z:\TestFromDC1.txt" -ItemType File -Force
Get-ChildItem Variable: | Out-File Z:\DC1-vars.txt

Z:\DC1-vars.txt
