Write-Host "==========| SysInfo Upload |==========`n`n`n`n`n`n" -ForegroundColor Cyan

Write-Host 'Getting computer system...' -ForegroundColor Yellow
$ComputerSystem = Get-WMIObject Win32_ComputerSystem
$RAM = "$([Math]::Ceiling($ComputerSystem.TotalPhysicalMemory / 1024 / 1024 / 1024))GB"

Write-Host 'Getting serial number...' -ForegroundColor Yellow
$SerialNumber = (Get-WMIObject Win32_BIOS).SerialNumber

Write-Host 'Getting processor...' -ForegroundColor Yellow
$CPU = (Get-WMIObject Win32_Processor).Name

Write-Host 'Getting operating system...' -ForegroundColor Yellow
$OS = (Get-ComputerInfo).WindowsProductName

Write-Host 'Getting boot disk...' -ForegroundColor Yellow
$Disk = Get-PhysicalDisk -SerialNumber (Get-Disk | Where BootFromDisk -eq $TRUE).SerialNumber


Write-Host 'Sending web request...' -ForegroundColor Yellow
$Body = @{
    manufacturer = $ComputerSystem.Manufacturer
    model = $ComputerSystem.Model
    serial = $SerialNumber
    cpu = $CPU
    ram = $RAM
    os = $OS
    disk_manufacturer = if ($Disk.Manufacturer -ne $null) { $Disk.Manufacturer } else { '' }
    disk_model = $Disk.Model
    disk_serial = $Disk.SerialNumber
} | ConvertTo-Json
Invoke-WebRequest -Uri unwyse.local -Method POST -Body $Body -ContentType 'application/json' -UseBasicParsing


Write-Host 'Done! Close the window or press any key to exit' -ForegroundColor Green
$null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown')
