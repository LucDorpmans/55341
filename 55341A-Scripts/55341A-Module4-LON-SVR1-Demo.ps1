#Module4 LON-STOR1 (VM on LON-HOST1)

# Show/Get Available & Poolable Physical Disks  
$PhysicalDisks = (Get-PhysicalDisk -CanPool $True)
$PhysicalDisks

# Show/Get known StorageSubsystem Friendly Names
Get-StorageSubSystem -FriendlyName *

# Create StoragePool:
New-StoragePool -FriendlyName DemoPool2 -StorageSubSystemFriendlyName 'Windows Storage*'  -PhysicalDisks $PhysicalDisks

# Display Pool info
Get-StoragePool | Select * | Out-GridView
Get-StoragePool -FriendlyName DemoPool2

# Create Virtual Disk
New-VirtualDisk -FriendlyName 'Demo vDisk 2' `
    -StoragePoolFriendlyName  "DemoPool2" `
    -ResiliencySettingName Simple  `
    -Size 5GB `
    -ProvisioningType Thin

# Prepare disk for Volume
$Newdisk = Get-Disk -FriendlyName "Simple vDisk 2"
$NewDisk | Initialize-Disk

New-Volume -Disk $NewDisk `
    -FriendlyName "Demo Volume 2" `
    -FileSystem ReFS `
    -AccessPath "G:" 


# Or create vDisk and Volume in one statement:
New-Volume -StoragePoolFriendlyName "DemoPool2" `
    -FriendlyName "Demo vDISK+Volume" `
    -FileSystem ReFS `
    -Size 5GB `
    -ProvisioningType Thin `
    -ResiliencySettingName Simple `
    -AccessPath "H:" `


# Remove everything
Remove-Partition -DriveLetter G, H

#Remove a specific VirtualDisk:
Get-VirtualDisk 'Demo vDisk 2' | Remove-VirtualDisk

#Remove all VirtualDisks:
Get-StoragePool DemoPool2 | Get-VirtualDisk | Remove-VirtualDisk

# Remove Storage Pool, freeing up Physical disks
Get-StoragePool DemoPool2 | Remove-StoragePool

# Get list of poolable disks:
$CanPoolDisks = Get-PhysicalDisk | where CanPool -eq 'true'

# Expanding a storage pool
Add-PhysicalDisk -PhysicalDisks  $CanPoolDisks -StoragePoolFriendlyName DemoPool1 


# To generate and collect performance data run the following cmdlet:
Measure-StorageSpacesPhysicalDiskPerformance -StorageSpaceFriendlyName DemoPool1  `
    -MaxNumberOfSamples 60 -SecondsBetweenSamples 2 -ReplaceExistingResultsFile  `
    -ResultsFilePath DemoPool1.blg -SpacetoPDMappingPath PDMap.csv 


# Currently ReFS does NOT support Deduplication!

# Installing and configuring Data Deduplication

	
# Install the Data Deduplication role service:
Install-WindowsFeature FS-Data-Deduplication

# Enable Data Deduplication
Enable-DedupVolume -Volume D: -UsageType Default  

# Check the status of Data Deduplication
Get-DedupStatus
Get-DedupVolume D: 

Get-DedupVolume D: | Set-DedupVolume -ExcludeFolder 'D:\Shares' -MinimumFileAgeDays 1 


Get-DedupSchedule 

# Start DedupJob:
Start-DedupJob -Volume D: -Type Optimization -Memory 50 -Priority High # -StopWhenSystemBusy

