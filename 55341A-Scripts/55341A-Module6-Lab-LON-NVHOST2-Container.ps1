# 20740C
# Module 6
# Container Demo

Docker images
docker run -d -p 80:80 microsoft/iis:windowsservercore cmd
docker container list # note/copy id

docker inspect 84c7a846a34f -f "{{ .NetworkSettings.Networks.nat.IPAddress }}" #insert id
docker inspect -f "{{ .NetworkSettings.Networks.nat.IPAddress }}" 84c7a846a34f

# Connect to HTTP://IP
Start-Process "http://172.20.131.145/"

docker ps -a

docker network inspect nat

docker stop 84c7a846a34f

docker rm 84c7a846a34f

# Using names & variables:
$ContImgName = "microsoft/iis:windowsservercore"
$ContName = "MyContainer"
docker run --name $ContName -it -d -p 80:80 $ContImgName cmd 

docker ps -a

$ContIP = docker inspect $ContName -f "{{ .NetworkSettings.Networks.nat.IPAddress }}" #insert id

Start-Process "http://$ContIp/"

# Get-Item WSMan:\localhost\Client\TrustedHosts 

