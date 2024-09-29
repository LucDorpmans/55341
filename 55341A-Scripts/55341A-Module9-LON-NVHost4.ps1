#20740C-Module9-LON-NVHost4

# 20740C
# Module 9 
# LON-NVHost4

$NetAdap = Get-NetAdapter
# Get-NetIPConfiguration -InterfaceAlias $NetAdap.InterfaceAlias
Get-NetIPConfiguration -InterfaceIndex $NetAdap.InterfaceIndex


#Clear Network configuration:
Get-NetAdapter | Get-NetIPConfiguration | Remove-NetIPAddress * -Confirm:$false
Set-DnsClientServerAddress -InterfaceIndex $NetAdap.InterfaceIndex -ResetServerAddresses
Remove-NetRoute -InterfaceIndex $NetAdap.InterfaceIndex -confirm:$false

Get-NetAdapter | Get-NetIPConfiguration | New-NetIPAddress -AddressFamily IPv4 -IPAddress 172.16.0.34 -PrefixLength 16 # -DefaultGateway 172.16.0.1 
Get-NetAdapter | Set-DnsClientServerAddress -ServerAddresses 172.16.0.10
New-NetRoute -InterfaceIndex $NetAdap.InterfaceIndex  -DestinationPrefix "0.0.0.0/0" -AddressFamily IPv4 -NextHop "172.16.0.1" -confirm:$false

#Check new network settings
Get-NetIPConfiguration 
Get-NetRoute