# Module 2 LON-SVR1 Labs:
# Exercise 1: Creating and managing volumes
# Task 1: Create a hard disk volume and format for ReFS

# Create a new volume formatted for ReFS by using all the available disk space on Disk 1. Use the following Windows PowerShell cmdlets to complete this process:
Get-Disk | Where-Object PartitionStyle -Eq "RAW" 
# Initialize disk 2:
Initialize-disk 2
# Review the partition table type:
Get-Disk 
# Create an ReFS volume by using all the available space on disk 1:
New-Partition -DiskNumber 2 -UseMaximumSize -AssignDriveLetter | Format-Volume  -NewFileSystemLabel "Simple" -FileSystem ReFS 


#Task 2: Create a mirrored volume:
# Initialize all remaining disks.

#Create a new volume on Disk 3 and Disk 4:
<#
DiskPart
Select disk 3
Convert Dynamic
Select disk 4
Convert Dynamic
create volume mirror disk=3,4
format fs=ntfs quick
assign letter=M
#>

#Exercise 2: Resizing volumes
#Task 1: Create a simple volume and resize it.
#Initialize disk 5: 
Initialize-disk 5

#Start diskpart:
diskpart
#List available disks: 
List disk
#Select the appropriate disk: 
Select disk 5
#Make the disk dynamic: 
Convert dynamic
#Create a simple volume on Disk 5: 
Create volume simple size=10000 disk=5
#Assign the drive letter Z: 
Assign letter=z
#Format the volume for NTFS: 
Format fs=NTFS quick

# In Disk Management, verify the presence of an NTFS volume on Disk 5 of size approximately 10 GB.
Extend size 10000
#In Disk Management, verify the presence of an NTFS volume on Disk 5 of size approximately 20 GB.

#Task 2: Shrink a volume.
Shrink desired=15000
# In Disk Management, verify the presence of an NTFS volume on Disk 5 of size approximately 5 GB.

