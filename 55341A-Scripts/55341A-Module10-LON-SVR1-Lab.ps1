# 20740
# Module 10
# LON-SVR1

Invoke-Command -Computername LON-SVR1,LON-SVR2 -command {Install-WindowsFeature NLB,RSAT-NLB}                     
New-NlbCluster -InterfaceName "Ethernet" -OperationMode Multicast -ClusterPrimaryIP 172.16.0.42 -ClusterName LON-NLB                                                                                                           

Add-NlbClusterNode -InterfaceName "Ethernet" -NewNodeName "LON-SVR2" -NewNodeInterface "Ethernet"
Invoke-Command -Computername LON-DC1 -command {Add-DNSServerResourceRecordA      –zonename adatum.com –name LON-NLB –Ipv4Address 172.16.0.42}

# Remove the default Rule:
Get-NlbClusterPortRule | Remove-NlbClusterPortRule

#Add the desired rules:
Add-NlbClusterPortRule -Interface Ethernet -Protocol Both -StartPort   80 -EndPort   80 -Mode Multiple -Affinity None 
Add-NlbClusterPortRule -Interface Ethernet -Protocol Both -StartPort 5678 -EndPort 5678 -Mode Single 

<# Removing a specific PortRule is difficult, this does not work
Get-NlbClusterPortRule | ForEach-Object { $_ | Fl *} 
Get-NlbClusterPortRule | Where-Object { $_.StartPort -eq 80 }
$NLBPortRules = Get-NlbClusterPortRule 
$NLBPortRules | ForEach-Object {
        If ($_.StartPort -eq 5678) { Remove-NlbClusterPortRule -InterfaceName Ethernet -IP $_.VirtualIPAddress }
    }
#>

