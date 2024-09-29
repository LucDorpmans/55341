#Module4 Lab A - LON-SVR1
# Exercise 1:

#Task 3: Copy a file to the volume, and verify it is visible in File Explorer

#On LON-SVR, open Command Prompt Type the following command:
Copy C:\windows\system32\write.exe H:\ 

# Task 6: Add a new disk to the storage pool and remove the broken disk
# In the STORAGE POOLS pane, right-click StoragePool1, click Add Physical Disk, and then add the first disk in the list.
$DiskToAdd =  Get-PhysicalDisk -CanPool $True | Where { $_.PhysicalLocation -match "LUN 6" }
Get-StoragePool StoragePool1 | Add-PhysicalDisk -PhysicalDisks $DiskToAdd 

# To remove the disconnected disk, open Windows PowerShell, and then run the following commands:
Get-PhysicalDisk
# Note: Note the FriendlyName for the disk that shows an OperationalStatus of Lost Communication. Use this disk name in the next command in place of diskname.
$Disk = Get-PhysicalDisk -FriendlyName ‘Generic Physical Disk’

Remove-PhysicalDisk -PhysicalDisks $disk -StoragePoolFriendlyName StoragePool1


# Exercise 2: Enabling and configuring storage tiering
# Task 1: Use the Get-PhysicalDisk cmdlet to view all available disks on the system

# On LON-SVR1, in Windows PowerShell (Admin), run the following command:
Get-PhysicalDisk 

# Task 2: Create a new storage pool
# In Windows PowerShell, run the following commands:
$canpool = Get-PhysicalDisk –CanPool $true 
New-StoragePool -FriendlyName "TieredStoragePool" -StorageSubsystemFriendlyName "Windows Storage*" -PhysicalDisks $canpool 

# Open File Explorer, and then run the following lines (from D:\Labfiles\Mod04\mod4.ps1 script): 
$i = 0
$disks = Get-StoragePool -FriendlyName TieredStoragePool | Get-PhysicalDisk
Foreach ($disk in $disks)
            {Get-PhysicalDisk -UniqueId $disk.UniqueID | Set-PhysicalDisk -NewFriendlyName (“PhysicalDisk$i”)
            $i++}
# This configures the disk names for the next part of the exercise.


# Task 3: View the media types

# To verify the media types, on LON-SVR1, in Windows PowerShell, run the following command:
Get-StoragePool –FriendlyName TieredStoragePool | Get-PhysicalDisk | Select FriendlyName, MediaType, Usage, BusType 

# Task 4: Specify the media type for the sample disks and verify that the media type is changed
# To configure the media types, on LON-SVR1, in Windows PowerShell, run the following commands:
Set-PhysicalDisk –FriendlyName PhysicalDisk1 –MediaType SSD 
Set-PhysicalDisk –FriendlyName PhysicalDisk0 –MediaType HDD 

# To verify the media types, run the following command:
Get-PhysicalDisk | Select FriendlyName, Mediatype, Usage, BusType 

# Task 5: Create pool-level storage tiers by using Windows PowerShell
# To create pool-level storage tiers, one for SSD media types and one for HDD media types, on LON-SVR1, in Windows PowerShell, run the following commands:
New-StorageTier –StoragePoolFriendlyName TieredStoragePool -FriendlyName HDD_Tier –MediaType HDD 
New-StorageTier –StoragePoolFriendlyName TieredStoragePool -FriendlyName SSD_Tier –MediaType SSD 


# Create TieredVirtualDisk
# Much easier to use the GUI ...
Get-VirtualDisk -FriendlyName Tiered* | Format-List

