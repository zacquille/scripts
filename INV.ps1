  # Define File Path !!!
  $file= 'C:/inventory.csv'
  
  $ComputerName =  Get-WmiObject Win32_OperatingSystem  | select -ExpandProperty CSName
    $OS_Name = Get-WmiObject Win32_OperatingSystem  | Select-Object -ExpandProperty Caption 
    $OS_Architecture = Get-WmiObject Win32_OperatingSystem  | select -ExpandProperty OSArchitecture
    $System_Manufacturer = Get-WmiObject win32_computersystem  | select -ExpandProperty Manufacturer
    $Model = Get-WmiObject win32_computersystem  | select -ExpandProperty Model
    $CPU_Manufacturer = Get-WmiObject Win32_Processor  | select -ExpandProperty Name
    $Disk_Size_GB = Get-WmiObject win32_diskDrive  | Measure-Object -Property Size -Sum | % {[math]::round(($_.sum /1GB),2)}
    $Physical_Memory_GB = Get-WMIObject -class Win32_PhysicalMemory  | Measure-Object -Property capacity -Sum | % {[Math]::Round(($_.sum / 1GB),2)}
    $Version=(Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion" -Name ReleaseId).ReleaseId
    $InstallDate= systeminfo | find /I “Install Date”
    $Assettag=(Get-WmiObject -Class Win32_SystemEnclosure | Select-Object SMBiosAssetTag).SMBiosAssetTag 
    $SerialNumber =  (Get-WmiObject -Class Win32_BIOS | Select-Object SerialNumber).SerialNumber

[PSCustomObject]@{
        "Assettag" = $Assettag
        "ComputerName" = $ComputerName
        "OS_Name" = $OS_Name
        "Version" = $Version
        "System_Manufacturer" = $System_Manufacturer
        "Model" = $Model
        "CPU_Manufacturer" = $CPU_Manufacturer
        "Disk_Size_GB" = $Disk_Size_GB
        "Physical_Memory_GB" = $Physical_Memory_GB
        "InstallDate" = $InstallDate
        "SerialNumber" = $SerialNumber
} | Export-Csv -Path $file -NoTypeInformation -Append
