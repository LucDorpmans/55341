Install-WindowsFeature –Name Hyper-V,Hyper-V-Tools,Hyper-V-PowerShell –Restart 

# From "E:\Program Files\Microsoft Learning\20740\Drives\CreateVirtualSwitches.ps1"
# See if a Private Switch named "Private Network" already exists and assign True or False value to the Variable to track if it does or not
$PrivateNetworkVirtualSwitchExists = ((Get-VMSwitch | where {$_.name -eq "Private Network" -and $_.SwitchType -eq "Private"}).count -ne 0)

if ($PrivateNetworkVirtualSwitchExists -eq "True")
{
write-host "< Private Network >   ---- switch already Exists"
} 
else
{
New-VMSwitch -SwitchName "Private Network" -SwitchType Private
}

# See if a Cluster Network Switch already exists assign True or False value to the Variable to track if it does or not
$PrivateVirtualSwitchExists = ((Get-VMSwitch | where {$_.name -eq "Cluster Network"}).count -ne 0)

# If statement to check if Cluster Network Switch already exists. If it does write a message to the host 
# saying so and if not create Cluster Network Virtual Switch
if ($PrivateVirtualSwitchExists -eq "True")
{
write-host "Cluster Network already Exists"
} 
else
{
New-VMSwitch -SwitchName "Cluster Network" -SwitchType Private
}

# See if a iSCSI Storage Network Switch already exists assign True or False value to the Variable to track if it does or not
$PrivateVirtualSwitchExists = ((Get-VMSwitch | where {$_.name -eq "iSCSI Storage Network"}).count -ne 0)

# If statement to check if iSCSI Storage Network Switch already exists. If it does write a message to the host 
# saying so and if not create iSCSI Storage Network Virtual Switch
if ($PrivateVirtualSwitchExists -eq "True")
{
write-host "iSCSI Storage Network already Exists"
} 
else
{
New-VMSwitch -SwitchName "iSCSI Storage Network" -SwitchType Private
}


# From 'E:\Program Files\Microsoft Learning\20740\Drives\LON-HOST2_VM-Pre-Import-20740C.ps1'
$path = $drive + "E:\Program Files\Microsoft Learning\Base\"
$path2 = $drive2 + "E:\Program Files\Microsoft Learning\20740\Drives\"

Set-VHD -Path (Get-Item ($path + "Drives\MT17A-LON-DC1.vhd")) -ParentPath (Get-Item ($path + "Base17C-WS16-1607.vhd"))
Set-VHD -Path (Get-Item ($path2 + "20740C-LON-DC1-C\Virtual Hard Disks\20740C-LON-DC1-C.vhd")) -ParentPath (Get-Item ($path + "Drives\MT17A-LON-DC1.vhd"))
Set-VHD -Path (Get-Item ($path2 + "20740C-LON-NVHOST3\Virtual Hard Disks\20740C-LON-NVHOST3.vhd")) -ParentPath (Get-Item ($path + "Base17C-WS16-1607.vhd"))
Set-VHD -Path (Get-Item ($path2 + "20740C-LON-NVHOST4\Virtual Hard Disks\20740C-LON-NVHOST4.vhd")) -ParentPath (Get-Item ($path + "Base17C-WS16-1607.vhd"))

Import-VM -Path (Get-Item ($path2 + "20740C-LON-DC1-C\Virtual Machines\*.xml"))
Import-VM -Path (Get-Item ($path2 + "20740C-LON-NVHOST3\Virtual Machines\*.vmcx"))
Import-VM -Path (Get-Item ($path2 + "20740C-LON-NVHOST4\Virtual Machines\*.vmcx"))

$VMName = "20740C-LON-NVHOST3"
$VMName = "20740C-LON-NVHOST4"

Set-VMProcessor -VMName $VMName -ExposeVirtualizationExtensions $true -Count 2 
Set-VMMemory $VMName -DynamicMemoryEnabled $false -StartupBytes 4GB
Get-VMNetworkAdapter -VMName $VMName | Set-VMNetworkAdapter -MacAddressSpoofing On 

Start-VM -VMName $VMName

$Cred = Get-Credential "adatum\administrator"

Enter-PSSession –VMName $VMName -Credential $Cred 
    Install-WindowsFeature -Name Failover-Clustering –IncludeManagementTools
    Install-WindowsFeature –Name Hyper-V,Hyper-V-Tools,Hyper-V-Powershell –Restart 
Exit-PSSession

Invoke-Command –VMName $VMName -Credential $Cred –FilePath "E:\Program Files\Microsoft Learning\20740\Drives\CreateVirtualSwitches.ps1" 

# On LON-NVHost3 and 4 do: Connect-IscsiTarget -TargetPortalAddress "172.16.0.10"

Enter-PSSession –VMName $VMName -Credential $Cred 
    # Install-WindowsFeature -Name Failover-Clustering –IncludeManagementTools
    Start-Service msiscsi 
    Set-Service msiscsi –StartupType "Automatic"
    Connect-IscsiTarget -TargetPortalAddress "ip.172.16.0.10" 
    Connect-IscsiTarget -TargetPortalAddress "iqn.1991-05.com.microsoft:lon-dc1-iscsi-target1-target"
    
    # -NodeAddress "172.16.0.34"
Exit-PSSession

 –ComputerName LON-NVHOST3

#Alternavitely:
Invoke-Command –VMName $VMName -Credential $Cred { Start-Service msiscsi }
Invoke-Command –VMName $VMName -Credential $Cred { Set-Service msiscsi –StartupType “Automatic” }
Invoke-Command –VMName $VMName -Credential $Cred { Connect-IscsiTarget -TargetPortalAddress "172.16.0.10" }


New-Cluster -Name VMCluster -Node LON-NVHOST3, LON-NVHOST4 -StaticAddress 172.16.0.126