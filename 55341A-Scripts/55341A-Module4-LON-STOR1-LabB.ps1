#Module4 Lab B - LON-SVR1
# Exercise 1:

#Task 1: Install the Data Deduplication Role Service:
Install-WindowsFeature FS-Data-Deduplication

#Task 1: To verify Data Deduplication status, run the following commands:
Get-DedupVolume 
Get-DedupStatus 

$MeasureResBefore = Measure-Command -Expression {Get-ChildItem -Path E:\ -Recurse} 

Enable-DedupVolume -Volume "E:" -UsageType Default  

Set-DedupVolume -Volume E: -MinimumFileAgeDays 0 
Set-DedupSchedule -Name ThroughputOptimization -Enabled $True  -Days Tuesday,Wednesday,Thursday,Friday,Saturday,Sunday -DurationHours 6

New-DedupSchedule -Name DedupSchedule1 -Type Optimization -Days Monday,Tuesday,Wednesday,Thursday,Friday,Saturday,Sunday -DurationHours 6
Get-DedupSchedule -Name DedupSchedule1 | Select -ExpandProperty Days
# ThroughputOptimization-2 
Get-DedupSchedule 

Start-DedupJob E: -Type Optimization -Memory 50

Get-DedupJob 


Get-DedupVolume -Volume E: | fl

$MeasureResAfter = Measure-Command -Expression {Get-ChildItem -Path E:\ -Recurse} 