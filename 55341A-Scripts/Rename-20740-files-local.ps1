Set-Location "D:\Stack\MCT\!MOC\WindowsServer\Server2022\M55341A - Installation, Storage, and Compute with Windows Server\20740C-Scripts\"

"D:\Stack\MCT\!MOC\WindowsServer\Server2022\M55341A - Installation, Storage, and Compute with Windows Server\20740C-Scripts\" -replace "20740C-", "55341A"

Dir "20740C-*" -File | gm

Dir "20740C-Modulex-Labs*" | % {($_.FullName -replace "20740C-", "55341A-")}

Dir "20740C-*" | Rename-Item -NewName { $_.Name -replace "20740C-", "55341A-" }




