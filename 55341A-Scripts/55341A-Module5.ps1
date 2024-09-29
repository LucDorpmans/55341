# Module 5
#Task 2: Enable nested virtualization

#On LON-HOST1, in Hyper-V Manager, upgrade the configuration version for 20740C-LON-NVHOST2.
Get-VM "20740C-LON-NVHOST2" | Update-VMVersion -Force

# Verify that the configuration version for 20740C-LON-NVHOST2 is now 8.0.
Get-VM "20740C-LON-NVHOST2" | Select VMName, Version, ProcessorCount


# Enable 
Set-VMProcessor -VMName 20740C-LON-NVHOST2 -ExposeVirtualizationExtensions $true -Count 4

#
Get-VMNetworkAdapter -VMName 20740C-LON-NVHOST2 | Set-VMNetworkAdapter -MacAddressSpoofing On 

#
Set-VM -VMName 20740C-LON-NVHOST2 -MemoryStartupBytes 4GB 

# Verify that the configuration for Nested Virtualization is OK:
Get-VM "20740C-LON-NVHOST2" | Select VMName, Version, ProcessorCount, MemoryStartup
Get-VM "20740C-LON-NVHOST2" | Get-VMProcessor | Select  VMName, Count, ExposeVirtualizationExtensions

Start-VM 20740C-LON-NVHOST2 

# Save Credentials
# When prompted, sign in as Adatum\Administrator by using Pa55w.rd as the password.
$Cred = Get-Credential -Credential "adatum\Administrator"

# Wait until LON-NVHOST2 has started.
Enter-PSSession -VMName 20740C-LON-NVHOST2 -Credential $Cred

# Use Windows PowerShell Direct to install Hyper-V on LON-NVHOST2.
Install-WindowsFeature -Name Hyper-V -IncludeAllSubFeature -IncludeManagementTools -Restart