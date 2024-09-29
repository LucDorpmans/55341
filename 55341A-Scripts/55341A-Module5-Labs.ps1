# 55341 
# Module 5
# Exercise 1: Verifying installation of the Hyper-V server role

$VMBasePath = 'D:\VMs'
$VMName = "LON-GUEST1"
New-Item "$VMBasePath\$VMName" -ItemType Directory -Force 
New-VHD “$VMBasePath\$VMName\$VMName.vhd” -ParentPath "D:\Server2022Base.vhd"
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

Add-VMDvdDrive -VMName $VMName -Path 'D:\Server2022Eval.iso'

$VMFw = Get-VMFirmware $VMName 
$MyDVD = Get-VMDvdDrive $VMName
$MyHD = Get-VMHardDiskDrive $VMName
$MyNIC = Get-VMNetworkAdapter $VMName
Set-VMFirmware $VMName -BootOrder $MyDVD, $MyHD, $MyNIC

Start-VM -VMName $VMName
# Quickly switch to VM and press any key to boot from DVD


# Task 3: Configure virtual machines
Set-VM -VMName LON-GUEST1 -DynamicMemory -ProcessorCount 4 -MemoryMaximumBytes 4GB
Set-VMNetworkAdapter -VMName LON-GUEST1  -MinimumBandwidthAbsolute 10MB -MaximumBandwidth 100MB

Get-VMIntegrationService  Lon-Guest2 | Select-Object Name, Enabled
Enable-VMIntegrationService -VMName Lon-Guest2 -Name "Guest Service Interface"

New-StorageQ -Name "MyQoSPolicy" -MinimumIops 500 -MaximumIops 1000 -Path "D:\QoSPolicies\MyQoSPolicy"
Set-VMHardDiskDrive -VMName "MyVM" -ControllerType SCSI -ControllerNumber 0 -ControllerLocation 0 -Path "D:\Hyper-V\MyVM\MyVHD.vhdx" -QoSPolicyID (Get-StorageQosPolicy -Name "MyQoSPolicy").PolicyID
Get-StorageQosFlow -InitiatorName "MyVM"

<# Module StorageQoS not installed ?!?
Get-Module -ListAvailable StorageQoS
Get-Command -Module StorageQoS
Get-StorageQoS

Find-Module StorageQoS
Import-Module StorageQoS #> 


# Create production SnapShot
# Add NIC
# Apply Snapshot

Get-VM Lon-Guest2 | Get-VMProcessor | Select *
Set-VMProcessor -VMName Lon-Guest2  –EnableHostResourceProtection $True


# Exercise 4: Enabling nested virtualization for a virtual machine

# Task 1: Import LON-NVHOST2
# New-VMSwitch -SwitchName "Isolated Network" -SwitchType Private
New-VMSwitch -SwitchName "Physical Network" -SwitchType External # Error ?!?
Get-VMSwitch -SwitchName "Physical Network"

New-VHD -Path D:\VMs\LON-NVHV.vhd -ParentPath D:\Server2022Base.vhd -Differencing
New-VM -Name LON-NVHV -MemoryStartupBytes 8192MB -VHDPath "D:\VMs\LON-NVHV.vhd" -SwitchName "Physical Network"
Set-VMProcessor -VMName LON-NVHV -count 4


#Task 2: Enable nested virtualization

# Verify that the configuration version for LON-NVHV is now 8.0.
Get-VM "LON-NVHV" | Select VMName, Version, ProcessorCount


# Enable 
Set-VMProcessor -VMName LON-NVHV -ExposeVirtualizationExtensions $true -Count 2

#
Get-VMNetworkAdapter -VMName LON-NVHV | Set-VMNetworkAdapter -MacAddressSpoofing On 

# Verify that the configuration for Nested Virtualization is OK:
Get-VM "LON-NVHV" | Select VMName, Version, ProcessorCount, MemoryStartup
Get-VM "LON-NVHV" | Get-VMProcessor | Select  VMName, Count, ExposeVirtualizationExtensions

Start-VM LON-NVHV 

# Save Credentials
# When prompted, sign in as Adatum\Administrator by using Pa55w.rd as the password.
$Cred = Get-Credential -Credential "Administrator"

# Wait until LON-NVHOST2 has started.
Enter-PSSession -VMName LON-NVHV -Credential $Cred

# Use Windows PowerShell Direct to install Hyper-V on LON-NVHV.
Install-WindowsFeature -Name Hyper-V -IncludeAllSubFeature -IncludeManagementTools -Restart

