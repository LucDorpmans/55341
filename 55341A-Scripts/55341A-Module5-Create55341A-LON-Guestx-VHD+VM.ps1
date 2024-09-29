# Module 5
Set-VHD "E:\20740C\20740C-BASE.vhd" -ParentPath "E:\Base\Base16D-WS16-TP5.vhd"

New-Item -ItemType Directory -Path "E:\20740C\LON-GuestX\"
New-VHD -Path "E:\20740C\LON-GuestX\Lon-GuestX.vhd" -ParentPath "E:\20740C\20740C-BASE.vhd" 

New-VM -Name LON-GuestX `
    -Path "E:\20740C\LON-GuestX\Virtual Machines" `
    -Generation 1 `
    -MemoryStartupBytes 1024MB `
    -SwitchName "Private Network"  `
    -VHDPath "E:\20740C\LON-GuestX\Lon-GuestX.vhd"


# Remove-VM -Name LON-GuestX 
# Remove-Item -path "E:\20740C\LON-GuestX" -Recurse