#Module 2 Demos:

# Get information using fsutil:
#region fsutil fsinfo

fsutil fsinfo volumeinfo f:
fsutil fsinfo sectorinfo f:
Get-Volume -DriveLetter F | format-list
Format-Volume -DriveLetter F -FileSystem ReFS -NewFileSystemLabel ReFSVolume
#endregion

#Choose correct disk!
$DiskNum = 2
Get-Disk 
Get-Disk -Number $DiskNum 
Get-Disk -Number $DiskNum | Initialize-Disk 					# Error when alreay initialized 

Get-Disk -Number $DiskNum | Get-Partition
Get-Disk -Number $DiskNum | New-Partition -Size 10Gb  
Get-Disk -Number $DiskNum | Clear-Disk 							# Fails if there are existing partitions
Get-Disk -Number $DiskNum | Get-Partition | Remove-Partition
Get-Disk -Number $DiskNum | Clear-Disk -RemoveData -Confirm:$False # Careful! Removes all partitions without asking and clears disk!

New-Partition -DiskNumber $DiskNum `
    -UseMaximumSize `
    -AssignDriveLetter | 
    Format-Volume  -NewFileSystemLabel "Simple" -FileSystem ReFS

Get-Disk -Number $DiskNum | Get-Partition -PartitionNumber 1 | Format-Volume -FileSystem ReFS
Get-Disk -Number $DiskNum | Get-Partition -PartitionNumber 2 | Format-Volume -FileSystem NTFS
Get-Disk -Number $DiskNum | Get-Partition -PartitionNumber 3 | Format-Volume -FileSystem exFAT
#endregion

#region VHD management
# Install the entire Hyper-V stack (hypervisor, services, and tools)
Install-WindowsFeature Hyper-V  -IncludeAllSubFeature -Restart

New-VHD -Path c:\sales.vhd `
	-Dynamic -SizeBytes 10Gb | 
	Mount-VHD -Passthru |
	Initialize-Disk -Passthru |
	New-Partition -AssignDriveLetter -UseMaximumSize |
	Format-Volume -FileSystem NTFS -Confirm:$false -Force 

$VHDPath = 'C:\'

New-VHD -Path $VHDPath\sales.vhd -Dynamic -SizeBytes 10Gb | 
	Mount-VHD -Passthru |
	Initialize-Disk -Passthru |
	New-Partition -AssignDriveLetter -UseMaximumSize |
	Format-Volume -FileSystem NTFS -Confirm:$false -Force 

Dismount-Vhd $VHDPath\sales.vhd

Get-Vhd $VHDPath\sales.vhd

Convert-VHD -Path $VHDPath\Sales.vhd -DestinationPath $VHDPath\Sales.vhdx 

Set-VHD -Path $VHDPath\Sales.vhdx -PhysicalSectorSizeBytes 4096 

Get-Vhd $VHDPath\sales.vhdx

Optimize-VHD -Path $VHDPath\Sales.vhdx -Mode Full
#endregion
