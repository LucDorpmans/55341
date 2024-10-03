Install-WindowsFeature -Name Failover-Clustering –IncludeManagementTools –ComputerName LON-SVR1
Install-WindowsFeature -Name Failover-Clustering –IncludeManagementTools –ComputerName LON-SVR2
Install-WindowsFeature -Name Failover-Clustering –IncludeManagementTools –ComputerName LON-SVR3

Install-WindowsFeature -Name RSAT-Clustering
Install-WindowsFeature -Name RSAT-Clustering –ComputerName LON-SVR1

Add-CauClusterRole -ClusterName Demo-Cluster -EnableFirewallRules

# Set-CauClusterRole -ClusterName Demo-Cluster -EnableFirewallRules 
# Invoke-CauRun 

# netsh winhttp set proxy MyProxy.CONTOSO.com:443 "<local>"

Get-Command Set-CauClusterRole
Get-Command -Module ClusterAwareUpdating    