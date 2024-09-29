Install-WindowsFeature -Name Failover-Clustering –IncludeManagementTools –ComputerName LON-SVR2
Install-WindowsFeature -Name Failover-Clustering –IncludeManagementTools –ComputerName LON-SVR3
Install-WindowsFeature -Name Failover-Clustering –IncludeManagementTools –ComputerName LON-SVR4

Install-WindowsFeature -Name RSAT-Clustering
Install-WindowsFeature -Name RSAT-Clustering –ComputerName LON-SVR1