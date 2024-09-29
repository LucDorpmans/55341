# Module 3 - LON-SVR1
# Demo Connect to the iSCSI target

# You could use the following Windows PowerShell cmdlets to manage your iSCSI initiator:
Get-NetFirewallServiceFilter -Service msiscsi | Get-NetFirewallRule | Select DisplayGroup,DisplayName,Enabled

Start-Service msiscsi 
Set-Service msiscsi –StartupType “Automatic” 
New-IscsiTargetPortal –TargetPortalAddress 10.10.100.201

Connect-IscsiTarget –NodeAddress "iqn.1991-05.com.microsoft:lon-stor1-iscsi-target1-target"


#region iSNS
#
# iSNS Server
#
# iscsicli FirewallExemptiSNSServer
Get-NetFirewallServiceFilter -Service msisnsserver | Get-NetFirewallRule | Select DisplayGroup,DisplayName,Enabled

# The following command allows outbound traffic to use an iSNS server for target discovery
#netsh advfirewall firewall> set rule "iSNS Server (TCP Out)" new enable=yes
New-NetFirewallRule -Name iSNS-TCP-Out -DisplayName “Allow iSNS”`  -Description “iSCSI Service (TCP-Out)”  -Enabled True -Profile Any -Action Allow 

# To add the iSNS Server to the iSCSI Initiator:
Set-WmiInstance `
  -Namespace root\wmi `
  -Class MSiSCSIInitiator_iSNSServerClass `
  -Arguments @{iSNSServerAddress="LON-DC1.ADATUM.COM"}


#To list the currently set iSNS Servers:
Get-WmiObject `
  -Class MSiSCSIInitiator_iSNSServerClass `
  -Namespace root\wmi


# To remove an iSNS Server from the iSCSI Initiator:
Get-WmiObject `
  -Class MSiSCSIInitiator_iSNSServerClass `
  -Namespace root\wmi `
  -Filter "iSNSServerAddress='LON-DC1'" | Remove-WmiObject -Verbose
#endregion iSNS

#region MPIO
#Demo MPIO
Add-WindowsFeature MultiPath-IO -IncludeManagementTools
Get-MPIOAvailableHW 
Enable-MSDSMAutomaticClaim -BusType iSCSI 
Get-MSDSMGlobalDefaultLoadBalancePolicy 
Set-MSDSMGlobalDefaultLoadBalancePolicy -Policy RR 
Set-MPIOSetting -NewDiskTimeout 60 
#endregion MPIO

#region SMB & NFS

Add-WindowsFeature FS-FileServer, FS-NFS-Service -IncludeManagementTools 

#Demo SMB
New-Item -ItemType Directory J:\Shares\DemoShare2
New-SMBShare -Name DemoShare2 `
    -Path J:\Shares\DemoShare2 `
    -FolderEnumerationMode AccessBased `
    -FullAccess "EVERYONE"
Get-SmbShare
Get-SmbShare DemoShare2 | Format-List *

#On LON-DC1 do:
#New-SmbMapping -LocalPath Z: -RemotePath \\172.16.0.21\DemoShare2
Get-SmbSession 
Get-SmbSession -ClientUserName Adatum\AdatumAdmin

Get-SmbOpenFile 

# NFS
New-Item -ItemType Directory K:\Shares\DemoNFSShare2
New-NfsShare -Name DemoNFSShare2 -Path K:\shares\DemoNFSShare2 # -Authentication krb5
# Remove-NfsShare DemoNFSShare2


#Task 4: Disable the legacy SMB1 protocol
#On LON-SVR1, at the Windows PowerShell prompt, type the following command, and then press Enter:
Set-SmbServerConfiguration -AuditSmb1Access $true 

#Type the following command, and then press Enter:
Get-SmbServerConfiguration | FL enable* 

#Type the following command, and then press Enter:
Set-SmbServerConfiguration -EnableSMB1Protocol $false 

#Type the following command, and then press Enter:
Get-WindowsFeature *SMB* 

# Type the following command, and then press Enter:
Remove-WindowsFeature FS-SMB1 
#endregion SMB & NFS


# Lab B: Implementing File Services

New-Item -ItemType Directory -Path D:\Data 

New-Item -ItemType Directory -Path D:\Data\Marketing
New-SmbShare Marketing -Path D:\Data\Marketing -ChangeAccess "Adatum\Marketing" -ReadAccess EveryOne

New-Item -ItemType Directory -Path D:\Data\Development
New-SmbShare Development -Path D:\Data\Development -ChangeAccess "Adatum\Development"

$Acl = Get-Acl D:\Development
$Acl | fl *
# Disable Inheritence, retain inherited permissions 
$Acl.SetAccessRuleProtection($False, $True)
$Acl.AreAccessRulesProtected
$Acl.SetAccessRuleProtection($True, $True)

