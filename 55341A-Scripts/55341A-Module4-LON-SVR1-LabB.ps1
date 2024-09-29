#Module4 Lab B - LON-SVR1
# Exercise 1:

#Task 1: Install the Data Deduplication Role Service:
Install-WindowsFeature FS-Data-Deduplication

#Task 1: To verify Data Deduplication status, run the following commands:
Get-DedupVolume 
Get-DedupStatus 
