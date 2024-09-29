# 20740C
# Module x
# Exercise 1: Verifying/installing the Hyper-V server role

Install-WindowsFeature –Name Hyper-V,Hyper-V-Tools,Hyper-V-PowerShell –Restart 
x:\Program Files\Microsoft Learning\20740\Drives\CreateVirtualSwitches.ps1 
x:\Program Files\Microsoft Learning\20740\Drives\LON-HOST2_VM-Pre-Import-20740B.ps1

$VMName = "20740B-LON-NVHOST3"
$VMName = "20740B-LON-NVHOST4"

Set-VMProcessor -VMName $VMName -ExposeVirtualizationExtensions $true -Count 2 
Set-VMMemory $VMName -DynamicMemoryEnabled $false 
Get-VMNetworkAdapter -VMName $VMName | Set-VMNetworkAdapter -MacAddressSpoofing On 

Enter-PSSession –VMName $VMName
Install-WindowsFeature –Name Hyper-V,Hyper-V-Tools,Hyper-V-Powershell –Restart 
Exit-PSSession

Invoke-Command –VMName $VMName  –FilePath “x:\Program Files\Microsoft Learning\20740\Drives\CreateVirtualSwitches.ps1” 

# On LON-NVHost3 and 4 do:
Connect-IscsiTarget -TargetPortalAddress "172.16.0.10"

