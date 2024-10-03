# On LON-HOST2, open Windows PowerShell.
# In the Windows PowerShell command prompt, type the following to install the NuGet provider:
Install-PackageProvider –Name NuGet –Force 

# Task 2: Install Docker
# In the Windows PowerShell command prompt, type the following to install Docker, and then press Enter:
Install-Module –Name DockerMsftProvider –Repository PSGallery –Force 
Install-Package -Name Docker -ProviderName DockerMsftProvider 

# Type the following to restart the computer, and then press Enter:
Restart-Computer -Force 


# Task 3: Manage the container

# On LON-NVHOST2, in the Windows PowerShell command prompt window, type the following to view the running containers, and then press Enter:
docker ps 

#Make a note of the container ID.
# Type the following to stop the container, and then press Enter:
docker stop <ContainerID>
#Note: Replace <ContainerID> with the container ID.

# On LON-HOST1, open Internet Explorer.
# In the address bar, type the following:
http://<ContainerhostIP>

# Observe that the default IIS page is no longer accessible. This is because the container is not running.

# On LON-NVHOST2, in the Windows PowerShell command window, type the following to delete the container:
docker rm <ContainerID>
# Note: Replace <ContainerID> with the container ID.