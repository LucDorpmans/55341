docker container run hello-world:nanoserver

Docker images

Docker search Microsoft

docker pull mcr.microsoft.com/windows/servercore/iis:windowsservercore-ltsc2022

Docker images

Docker run -d -p 8080:80 --name ContosoSite mcr.microsoft.com/windows/servercore/iis:windowsservercore-ltsc2022 cmd

ipconfig


docker ps

docker stop ContosoSite

docker ps

docker start ContosoSite
docker exec ContosoSite hostname
docker exec ContosoSite ipconfig

#Run in separate PowerShell console 
docker exec  -i ContosoSite cmd 


docker exec ContosoSite cmd /c 'type C:\inetpub\wwwroot\iisstart.htm'


# Run in ISE (doesn't work (yet))
docker exec ContosoSite cmd /c 'type "<HTML>Contoso Container from ISE</HTML>" > C:\inetpub\wwwroot\iisstart.htm'
