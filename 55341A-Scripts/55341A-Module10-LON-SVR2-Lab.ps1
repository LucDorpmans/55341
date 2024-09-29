# 20740
# Module 10
# LON-SVR2

# On LON-SVR1:
<#
Invoke-Command -Computername LON-SVR1,LON-SVR2 -command {Install-WindowsFeature NLB,RSAT-NLB}                     
New-NlbCluster -InterfaceName "Ethernet" -OperationMode Multicast -ClusterPrimaryIP 172.16.0.42 -ClusterName LON-NLB                                                                                                           

Add-NlbClusterNode -InterfaceName "Ethernet" -NewNodeName "LON-SVR2" -NewNodeInterface "Ethernet"
#>

New-Item -ItemType Directory "C:\PortTest"

Copy-Item "C:\inetpub\wwwroot\" C:\PortTest -Recurse 

New-Website -Name PortTest -PhysicalPath C:\PortTest\wwwroot -Port 5678
New-NetFirewallRule -DisplayName PortTest -Protocol TCP -LocalPort 5678


