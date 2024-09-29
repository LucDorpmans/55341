# GetMy-55341-Scripts.ps1
Function Get-MyScript { Param( [string]$AScript,[switch]$EditFile = $False, 
							   [string]$SPath = "$env:USERPROFILE\Downloads\")
			Invoke-Webrequest -Uri "https://raw.githubusercontent.com/LucDorpmans/My-Base-Repo/main/$AScript"  -Outfile "$SPath$AScript" 
If ($EditFile) { PSEdit ("$SPath$AScript" )} }

Invoke-WebRequest -uri "https://github.com/LucDorpmans/$MyRepo/archive/refs/heads/main.zip" -OutFile "$env:USERPROFILE\Downloads\$MyRepo.zip"
Expand-Archive "$env:USERPROFILE\Downloads\$MyRepo.zip" -DestinationPath C:\ -Force
