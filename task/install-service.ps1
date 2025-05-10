param (
    [string]$ExeSourcePath,
    [string]$InstallPath,
    [string]$ServiceName,
    [string]$DisplayName,
    [string]$ServiceAccountType = "LocalSystem",
    [string]$Username,
    [string]$Password,
    [string]$StartType = "auto",
    [string]$EndpointConfigurationType
)

$logFile = Join-Path -Path $env:Temp -ChildPath "$ServiceName-install-log.txt"
function Log($message) {
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logLine = "$timestamp - $message"
    Write-Host "##[section]$logLine"
    Add-Content -Path $logFile -Value $logLine
}

Log "Starting installation of NServiceBus service: $ServiceName"

# Stop and remove existing service if it exists
$existingService = Get-Service -Name $ServiceName -ErrorAction SilentlyContinue
if ($existingService) {
    Log "Stopping existing service: $ServiceName"
    Stop-Service -Name $ServiceName -Force -ErrorAction SilentlyContinue

    Log "Waiting 30 seconds before uninstalling service"
    Start-Sleep -Seconds 30

    Log "Deleting existing service: $ServiceName"
    sc.exe delete $ServiceName | Out-Null
} else {
    Log "No existing service named $ServiceName found"
}

# Clear old install path if exists
if (Test-Path $InstallPath) {
    Log "Removing previous install directory: $InstallPath"
    Remove-Item -Path $InstallPath -Recurse -Force
}
Log "Creating new install directory: $InstallPath"
New-Item -ItemType Directory -Force -Path $InstallPath | Out-Null

Log "Copying EXE to install directory"
Copy-Item -Path $ExeSourcePath -Destination $InstallPath -Force

$ExeFileName = [System.IO.Path]::GetFileName($ExeSourcePath)
$FinalExePath = Join-Path $InstallPath $ExeFileName

# Prepare installation command
$installCommand = "`"$FinalExePath`" install /servicename:`"$ServiceName`" /displayname:`"$DisplayName`""
if ($EndpointConfigurationType) {
    $installCommand += " /endpointConfigurationType:`"$EndpointConfigurationType`""
}
if ($ServiceAccountType -eq "Custom" -and $Username -and $Password) {
    $installCommand += " /username:`"$Username`" /password:`"$Password`""
}

Log "Running install command: $installCommand"
Invoke-Expression $installCommand

# Start the new service
Log "Starting new service: $ServiceName"
& $FinalExePath start

Log "Service '$ServiceName' successfully installed and started"