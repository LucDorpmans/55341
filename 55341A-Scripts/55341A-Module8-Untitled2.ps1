Rule ID: 1
Title: The failover cluster must be available
Result: Passed

Rule ID: 2
Title: The failover cluster nodes must be enabled for remote management via WMIv2
Result: Passed

Rule ID: 3
Title: Windows PowerShell remoting should be enabled on each failover cluster node
Result: Passed

Rule ID: 4
Title: The failover cluster must be running Windows Server 2012 or a higher version of Windows Server
Result: Passed

Rule ID: 5
Title: The required versions of .NET Framework and Windows PowerShell must be installed on all failover cluster nodes
Result: Passed

Rule ID: 6
Title: The Cluster service should be running on all cluster nodes
Result: Passed

Rule ID: 7
Title: Automatic Updates must not be configured to automatically install updates on any failover cluster node
Result: Passed

Rule ID: 8
Title: The failover cluster nodes should use the same update source
Result: Passed

Rule ID: 9
Title: A firewall rule that allows remote shutdown should be enabled on each node in the failover cluster
Result: Error
Problem: One or more failover cluster nodes do not have a firewall rule enabled that allows remote shutdown
Impact: Cluster-Aware Updating may not be able to update this failover cluster. An Updating Run that applies updates that require restarting the nodes may not complete properly.
Resolution: If a firewall is in use on the failover cluster nodes, configure a firewall rule to allow the coordinator computer to restart the cluster nodes. 
To do this, if Windows Firewall is in use, enable the "Remote Shutdown" firewall rule group for the Domain profile on the failover cluster nodes, 
or pass the -EnableFirewallRules parameter to the Invoke-CauRun or Set-CauClusterRole Windows PowerShell cmdlet. If a non-Microsoft firewall is in use, configure and enable a firewall rule that enables inbound TCP traffic for the wininit.exe program using RPC Dynamic Ports.
Help: https://go.microsoft.com/fwlink/p/?LinkId=245525
Problem on: LON-SVR1, LON-SVR2, LON-SVR3

Rule ID: 10
Title: The machine proxy on each failover cluster node should be set to a local proxy server
Result: Warning
Problem: One or more failover cluster nodes have an incorrect machine proxy server configuration.
Impact: Cluster-Aware Updating cannot update this failover cluster in a deployment scenario where the failover cluster must directly access Windows Update/Microsoft Update or the local Windows Server Update Services server for downloading updates.
Resolution: Ensure that the machine proxy on each cluster node is appropriately set to a local proxy server.
Help: https://go.microsoft.com/fwlink/p/?LinkId=245514
Problem on: LON-SVR1, LON-SVR2, LON-SVR3

Rule ID: 11
Title: The CAU clustered role should be installed on the failover cluster to enable self-updating mode
Result: Warning
Problem: The CAU clustered role is not installed on this failover cluster. This role is required for cluster self-updating.
Impact: This failover cluster cannot self-update using Cluster-Aware Updating. However, you can use the remote-updating mode of Cluster-Aware Updating.
Resolution: If you want this failover cluster to be self-updating, add the CAU clustered role on this failover cluster in one of two ways: run the Add-CauClusterRole Windows PowerShell cmdlet, or select the "Configure cluster self-updating options" action on the main console in the Cluster-Aware Updating tool.
Help: https://go.microsoft.com/fwlink/p/?LinkId=245515
Problem on: DEMO-Cluster

