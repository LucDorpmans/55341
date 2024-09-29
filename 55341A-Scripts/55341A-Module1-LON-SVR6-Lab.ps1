Install-WindowsFeature DNS                                                                                        

#Goto LON-DC1 and configure Secondary DNS Zone for Adatum remotely

dnscmd /enumzones                                                                                                 
dnscmd LON-DC1 /enumzones                                                                                         
Get-DnsClientServerAddress                                                                                        
Set-DnsClientServerAddress -InterfaceIndex 5 -ServerAddresses ("172.16.0.26", "172.16.0.10")                      
Get-DnsClientServerAddress                                                                                        
