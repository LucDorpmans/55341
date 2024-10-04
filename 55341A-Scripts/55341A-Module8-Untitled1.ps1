$MyRepo = "LD-55341-Repo"
$MyScript = "GetMy-55341-Scripts.ps1"
Invoke-Webrequest -Uri "https://raw.githubusercontent.com/LucDorpmans/$MyRepo/main/$MyScript"  -Outfile "$env:USERPROFILE\Downloads\$MyScript"

PSEdit  ("$env:USERPROFILE\Downloads\$MyScript")
