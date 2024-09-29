# Module 5
# Exercise 1: Verifying installation of the Hyper-V server role

$VMBasePath = 'E:\Program Files\Microsoft Learning\20740\Drives'
$VMName = "LON-GUEST1"
New-Item "$VMBasePath\$VMName" -ItemType Directory -Force 
New-VHD “$VMBasePath\$VMName\$VMName.vhd” -ParentPath "E:\Program Files\Microsoft Learning\Base\Base17C-WS16-1607.vhd"
Get-ChildItem  $VMBasePath\$VMName

#Create VM
New-VM -Name $VMName `
    -Path $VMBasePath\$VMName `
    -Generation 1 `
    -MemoryStartupBytes 1024MB `
    -SwitchName  'Isolated Network' `
    -VHDPath "$VMBasePath\$VMName\$VMName.vhd"

Start-VM -VMName $VMName

# Create another VM:

$VMName = "LON-GUEST2"
New-Item "$VMBasePath\$VMName" -ItemType Directory -Force 
New-VHD “$VMBasePath\$VMName\$VMName.vhdx” -SizeBytes 64GB -Dynamic 
Get-ChildItem  $VMBasePath\$VMName

#Create VM
New-VM -Name $VMName `
    -Path $VMBasePath\$VMName `
    -Generation 2 `
    -MemoryStartupBytes 2048MB `
    -SwitchName  'Isolated Network' `
    -VHDPath "$VMBasePath\$VMName\$VMName.vhdx"

New-Item 'E:\Program Files\Microsoft Learning\20740\Drives\LON-GUEST2' -ItemType Directory -Force 
New-VHD “E:\Program Files\Microsoft Learning\20740\Drives\LON-GUEST2\LON-GUEST2.vhdx” 
Get-ChildItem 'E:\Program Files\Microsoft Learning\20740\Drives\LON-GUEST2' -Recurse

Add-VMDvdDrive -VMName $VMName -Path 'E:\Program Files\Microsoft Learning\20740\Drives\WinServer2016_1607.iso'

$VMFw = Get-VMFirmware $VMName 
$MyDVD = Get-VMDvdDrive $VMName
$MyHD = Get-VMHardDiskDrive $VMName
$MyNIC = Get-VMNetworkAdapter $VMName
Set-VMFirmware $VMName -BootOrder $MyDVD, $MyHD, $MyNIC

Start-VM -VMName $VMName
# Quickly switch to VM and press any key to boot from DVD

# Exercise 4: Enabling nested virtualization for a virtual machine

# Task 1: Import LON-NVHOST2
New-VMSwitch -SwitchName "Isolated Network" -SwitchType Private
New-VMSwitch -SwitchName "Host Internal Network" -SwitchType Internal

#Task 2: Enable nested virtualization

#On LON-HOST1, in Hyper-V Manager, upgrade the configuration version for 20740B-LON-NVHOST2.
Get-VM "20740C-LON-NVHOST2" | Update-VMVersion -Force

# Verify that the configuration version for 20740B-LON-NVHOST2 is now 8.0.
Get-VM "20740C-LON-NVHOST2" | Select VMName, Version, ProcessorCount


# Enable 
Set-VMProcessor -VMName 20740C-LON-NVHOST2 -ExposeVirtualizationExtensions $true -Count 2

#
Get-VMNetworkAdapter -VMName 20740C-LON-NVHOST2 | Set-VMNetworkAdapter -MacAddressSpoofing On 

#
Set-VM -VMName 20740B-LON-NVHOST2 -MemoryStartupBytes 4GB 

# Verify that the configuration for Nested Virtualization is OK:
Get-VM "20740B-LON-NVHOST2" | Select VMName, Version, ProcessorCount, MemoryStartup
Get-VM "20740B-LON-NVHOST2" | Get-VMProcessor | Select  VMName, Count, ExposeVirtualizationExtensions

Start-VM 20740B-LON-NVHOST2 

# Save Credentials
# When prompted, sign in as Adatum\Administrator by using Pa55w.rd as the password.
$Cred = Get-Credential -Credential "adatum\Administrator"

# Wait until LON-NVHOST2 has started.
Enter-PSSession -VMName 20740C-LON-NVHOST2 -Credential $Cred

# Use Windows PowerShell Direct to install Hyper-V on LON-NVHOST2.
Install-WindowsFeature -Name Hyper-V -IncludeAllSubFeature -IncludeManagementTools -Restart