# Module 5
# Demo: Install Hyper-V
Install-WindowsFeature -Name Hyper-V -IncludeAllSubFeature -IncludeManagementTools -Restart

# Use Explorer to create folder 'D:\VMs\LON-GUEST1' 
New-Item 'D:\VMs\LON-GUEST1' -ItemType Directory -Force 

# New-VHD "D:\VMs\LON-GUEST1\LON-GUEST1.vhd" -ParentPath "E:\Base\Base17C-WS16-1607.vhd" 
New-VHD "D:\VMs\LON-GUEST1\LON-GUEST1.vhd" `
    -ParentPath "D:\Server2022Base.vhd"
Get-ChildItem 'D:\VMs\LON-GUEST1\' -Recurse

# Demonstration Steps (GUI)

# In Hyper-V Manager, use the Virtual Switch Manager to create a new external virtual network switch with the following properties:
# Name: Corporate Network
# Connection type: External Network: Mapped to the host computer's physical network adapter. Varies depending on the host computer.
New-VMSwitch -SwitchName "Corporate Network" -SwitchType Private

# Name: Private Network
# Connection type: Private network
New-VMSwitch -SwitchName "Private Network" -SwitchType Private
<#
Use Hyper-V Manager to create a virtual machine with the following properties:

Name: LON-GUEST1
Location: E:\Program Files\Microsoft Learning\20740\Drives\LON-GUEST1\
Generation: Generation 1
Memory: 1024 MB
Use Dynamic Memory: Yes
Networking: Private Network
Connect Virtual Hard Disk: E:\Program Files\Microsoft Learning\20740\Drives \LON-GUEST1\lon-guest1.vhd
New-VM –Name LON-GUEST1 –MemoryStartupBytes 1024MB –VHDPath 'E:\20740\LON-GUEST1\LON-GUEST1.vhd' –SwitchName "Private Network"
#> 
# Use PowerShell to create LON-Guest 1:
New-VM –Name LON-GUEST1 `
    –MemoryStartupBytes 1024MB `
    –VHDPath 'D:\VMs\LON-GUEST1\LON-GUEST1.vhd' `
    –SwitchName "Private Network" `
    -Generation 1
Get-VM LON-Guest1 | Set-VM -AutomaticStartAction Nothing -AutomaticStopAction ShutDown -ProcessorCount 4

# Use Explorer to create folder 'E:\20740\LON-GUEST2' 
New-Item 'D:\VMs\LON-GUEST2' -ItemType Directory -Force 

# New-VHD "D:\VMs\LON-GUEST1\LON-GUEST2.vhd" -ParentPath "E:\Base\Base17C-WS16-1607.vhd" 
New-VHD "D:\VMs\LON-GUEST2\LON-GUEST2.vhdx" -SizeBytes 48GB
Get-ChildItem 'D:\VMs' -Recurse

# Use PowerShell to create LON-Guest 2:
New-VM –Name LON-GUEST2 –MemoryStartupBytes 1024MB –VHDPath 'D:\VMs\LON-GUEST2\LON-GUEST2.vhdx' –SwitchName "Private Network" -Generation 2
Get-VM LON-Guest2 | Set-VM -AutomaticStartAction Nothing -AutomaticStopAction ShutDown -ProcessorCount 4
Set-VMProcessor LON-GUEST2 -EnableHostResourceProtection $true

Add-VMDvdDrive -VMName LON-Guest2 -ControllerNumber 0 -ControllerLocation 2
Set-VMDvdDrive -VMName LON-Guest2 -ControllerNumber 0 -ControllerLocation 2 -Path "D:\Server2022Eval.iso"
$VMDVDDrive = Get-VMDvdDrive  -VMName LON-Guest2  
Set-VMFirmware -VMName LON-Guest2  -FirstBootDevice $VMDVDDrive

<#
Demonstration Steps
1. In Hyper-V Manager, open the settings for LON-GUEST1 and verify that the Checkpoint Type is set to Production Checkpoints.
2. Create a checkpoint for LON-GUEST1.
3. Open the settings for LON-GUEST1, and change the Checkpoint Type to Standard Checkpoints.
4. Create a checkpoint for LON-GUEST1.
5. Delete the checkpoint subtree for LON-GUEST1.
#>


# # #
# Labs for copying Demo steps:
# # # 

# Exercise 4: Enabling nested virtualization for a virtual machine

# Task 1: Import LON-NVHOST2


#Task 2: Enable nested virtualization

#On LON-HOST1, in Hyper-V Manager, upgrade the configuration version for 20740B-LON-NVHOST2.
Get-VM "20740B-LON-NVHOST2" | Update-VMVersion -Force

# Verify that the configuration version for 20740B-LON-NVHOST2 is now 8.0.
Get-VM "20740B-LON-NVHOST2" | Select VMName, Version, ProcessorCount


# Enable 
Set-VMProcessor -VMName 20740B-LON-NVHOST2 -ExposeVirtualizationExtensions $true -Count 4

#
Get-VMNetworkAdapter -VMName 20740B-LON-NVHOST2 | Set-VMNetworkAdapter -MacAddressSpoofing On 

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
Enter-PSSession -VMName 20740B-LON-NVHOST2 -Credential $Cred

# Use Windows PowerShell Direct to install Hyper-V on LON-NVHOST2.
Install-WindowsFeature -Name Hyper-V -IncludeAllSubFeature -IncludeManagementTools -Restart