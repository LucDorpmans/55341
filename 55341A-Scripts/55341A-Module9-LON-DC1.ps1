Install-WindowsFeature -Name Failover-Clustering –IncludeManagementTools –ComputerName LON-HV1
Install-WindowsFeature -Name Failover-Clustering –IncludeManagementTools –ComputerName LON-HV2

Install-WindowsFeature -Name RSAT-Clustering

Add-CauClusterRole -ClusterName Demo-Cluster -EnableFirewallRules

# Set-CauClusterRole -ClusterName Demo-Cluster -EnableFirewallRules 
# Invoke-CauRun 

# netsh winhttp set proxy MyProxy.CONTOSO.com:443 "<local>"

Get-Command Set-CauClusterRole
Get-Command -Module ClusterAwareUpdating    