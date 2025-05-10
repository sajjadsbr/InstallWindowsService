param (
    [string]$sourcePublishedPath,
    [string]$installPath,
    [string]$serviceName,
    [string]$displayName,
    [string]$serviceAccountType = "LocalSystem",
    [string]$username,
    [string]$password,
    [string]$startType = "auto",
    [string]$endpointConfigurationType
)

$logFile = Join-Path -Path $env:Temp -ChildPath "$serviceName-install-log.txt"
function Log($message) {
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logLine = "$timestamp - $message"
    Write-Host "##[section]$logLine"
    Add-Content -Path $logFile -Value $logLine
}

Log "Starting installation of NServiceBus service: $serviceName"

# Stop and remove existing service if it exists
$existingService = Get-Service -Name $serviceName -ErrorAction SilentlyContinue
if ($existingService) {
    Log "Stopping existing service: $serviceName"
    Stop-Service -Name $serviceName -Force -ErrorAction SilentlyContinue

    Log "Waiting 30 seconds before uninstalling service"
    Start-Sleep -Seconds 30

    Log "Deleting existing service: $serviceName"
    sc.exe delete $serviceName | Out-Null
} else {
    Log "No existing service named $serviceName found"
}

# Clear old install path if exists
if (Test-Path $installPath) {
    Log "Removing previous install directory: $installPath"
    Remove-Item -Path $installPath -Recurse -Force
}
Log "Creating new install directory: $installPath"
New-Item -ItemType Directory -Force -Path $installPath | Out-Null

# Copy all files from source published path
Log "Copying all files from source published path: $sourcePublishedPath to $installPath"
if (-not (Test-Path $sourcePublishedPath)) {
    Log "Source published path $sourcePublishedPath does not exist"
    exit 1
}
Copy-Item -Path "$sourcePublishedPath\*" -Destination $installPath -Recurse -Force

# Find the first .exe file for installation
$exeFileName = Get-ChildItem -Path $installPath -Filter "*.exe" | Select-Object -First 1 -ExpandProperty Name
if (-not $exeFileName) {
    Log "No .exe file found in $installPath after copying"
    exit 1
}
$finalExePath = Join-Path $installPath $exeFileName

# Prepare installation command
$installCommand = "`"$finalExePath`" install /servicename:`"$serviceName`" /displayname:`"$displayName`""
if ($endpointConfigurationType) {
    $installCommand += " /endpointConfigurationType:`"$endpointConfigurationType`""
}
if ($serviceAccountType -eq "Custom" -and $username -and $password) {
    $installCommand += " /username:`"$username`" /password:`"$password`""
}

Log "Running install command: $installCommand"
Invoke-Expression $installCommand

# Start the new service
Log "Starting new service: $serviceName"
& $finalExePath start

Log "Service '$serviceName' successfully installed and started"