# 55341A-Module9-LON-HV2

Install-WindowsFeature -Name Hyper-V,Hyper-V-Tools,Hyper-V-Powershell -Restart

Install-WindowsFeature -Name Failover-Clustering –IncludeManagementTools –ComputerName LON-HV1
Install-WindowsFeature -Name Failover-Clustering –IncludeManagementTools –ComputerName LON-HV2

# New-Cluster -Name VMCluster -Node LON-HV1, LON-HV2 -StaticAddress 172.16.0.126

Get-ClusterQuorum

