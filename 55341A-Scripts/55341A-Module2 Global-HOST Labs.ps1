# :

#Exercise 3: Managing virtual hard disks
$VHDPath = 'C:\'

# Task 2: Create a virtual hard disk
New-VHD -Path $VHDPath\sales.vhd -Dynamic -SizeBytes 10Gb | 
	Mount-VHD -Passthru |
	Initialize-Disk -Passthru |
	New-Partition -AssignDriveLetter -UseMaximumSize |
	Format-Volume -FileSystem NTFS -Confirm:$false -Force 

<#
New-VHD -Path $VHDPath\sales.vhd -Dynamic -SizeBytes 10Gb 
$VDisk = Mount-VHD $VHDPath\sales.vhd -Passthru
$VDisk | Initialize-Disk -PassThru
$Vol = ($Res | New-Partition -AssignDriveLetter -UseMaximumSize)
$Letter = ($Vol |Format-Volume -FileSystem NTFS -Confirm:$false -Force )
#>

Dismount-Vhd $VHDPath\sales.vhd

Get-Vhd $VHDPath\sales.vhd

Convert-VHD -Path $VHDPath\Sales.vhd -DestinationPath $VHDPath\Sales.vhdx 

Set-VHD -Path $VHDPath\Sales.vhdx -PhysicalSectorSizeBytes 4096 

Get-Vhd $VHDPath\sales.vhdx

Optimize-VHD -Path $VHDPath\Sales.vhdx -Mode Full

Mount-VHD $VHDPath\sales.vhdx

Dismount-Vhd $VHDPath\sales.vhdx

Remove-Item F:\20740B\sales.vhd, F:\20740B\sales.vhdx	
