# Ex. 1:
# Task 1:
MkDir C:\Nano
Copy *.ps* D:\NanoServer\NanoServerImageGenerator\ C:\Nano

#Task 2:
Import-Module c:\nano\NanoServerImageGenerator.psm1

#Task 3:
New-NanoServerImage -Edition Standard `
    -MediaPath D:\ `
    -BasePath C:\Nano\ `
    -TargetPath C:\Nano\Nano-Svr1.vhdx `
    -DeploymentType Guest `
    -ComputerName NANO-SVR1 `
    -Storage `
    -Package Microsoft-NanoServer-IIS-Package

#Ex. 2:
#Task 1: 
# Get the IP address from the recovery console:
# ip = 172.16.0.16?
$ip = "172.16.0.161"

#Task 2:
#On LON-DC1:
djoin.exe /provision /domain adatum /machine NANO-SVR1 /savefile .\odjblob.dat

Set-Item WSMan:\localhost\Client\TrustedHosts $ip
Enter-PSSession -ComputerName $ip -Credential $ip\Administrator
netsh advfirewall firewall set rule group="File and Printer Sharing" new enable=yes
Exit-PSSession
net use Z: \\$ip\c$
Copy-Item C:\Windows\System32\odjblob.dat Z:


#Module 1
#Excercise 2:
# $ip = "172.16.0.16?"
$Cred = Get-Credential -UserName "$ip\Administrator"
Set-Item WSMan:\localhost\Client\TrustedHosts $ip

Enter-PSSession -ComputerName $ip -Credential $Cred
netsh advfirewall firewall set rule group="File and Printer Sharing" new enable=yes
Exit-PSSession

Set-Location C:\Users\Administrator

#New-SmbMapping -LocalPath Z: -RemotePath \\172.16.0.160\c$
#Copy-Item C:\Users\Administrator\odjblob.dat Z:\
Copy-Item C:\Users\Administrator\odjblob.dat \\172.16.0.160\c$


Enter-PSSession -ComputerName $ip -Credential $ip\Administrator
djoin /requestodj /loadfile c:\odjblob.dat /windowspath c:\windows /localos 
Restart-Computer


#Task 3:
Get-WindowsFeature -ComputerName NANO-SVR1
Install-WindowsFeature Fs-fileserver -ComputerName NANO-SVR1

#Exercise 3: Performing remote management
#Task 1 
### interactive with GUI

#Task 2
# $ip = "172.16.0.16?"
$Cred = Get-Credential -Credential "$ip\Administrator"
Enter-PSSession -ComputerName $ip -Credential $Cred
    New-Item -ItemType Directory -Path C:\Shares\Data -Force
    New-SmbShare -Name Test -Path C:\Shares\Data
    '<H1> Nano Server WebSite </H1>' | Out-File C:\InetPub\WWWRoot\Default.htm
Exit-PSSession

Invoke-WebRequest http://NANO-SVR1/
New-SmbMapping -LocalPath Y: -RemotePath \\NANO-SVR1\Data