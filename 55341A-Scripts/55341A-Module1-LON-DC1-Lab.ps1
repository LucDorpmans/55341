# 20740C-Module1-LON-DC1-Lab.ps1

Get-DnsServerZone -Name Adatum.com | Select ZoneName, NotifyServers, SecureSecondaries
<# Dit werkt nog niet

(Get-DnsServerZone -Name Adatum.com).SecureSecondaries = $True
(Get-DnsServerZone -Name Adatum.com).NotifyServers = "172.16.0.26"

# Goto LON-SVR6 and configure check DNS configuration


Set-DnsServerZoneTransferPolicy -ZoneName Adatum.com 
(Get-DnsServerZone -Name Adatum.com).NotifyServers = $null

Set-DnsServerPrimaryZone -Name Adatum.com -Notify NotifyServers 
#>
