
# IT Workstation Health Check
# Collects basic Windows system information
# Read-only: Does not modify system settings

Write-Host "================================="
Write-Host "  IT WORKSTATION HEALTH CHECK"
Write-Host "================================="
Write-Host ""

# Get Windows system information
$os = Get-CimInstance Win32_OperatingSystem
$computer = Get-CimInstance Win32_ComputerSystem
$processor = Get-CimInstance Win32_Processor

# Computer name
Write-Host "Computer Name: $env:COMPUTERNAME"

# Windows version
Write-Host "Operating System: $($os.Caption)"
Write-Host "Windows Build: $($os.BuildNumber)"

# Processor information
Write-Host "Processor: $($processor.Name)"

# Total installed memory
$ramGB = [math]::Round(
    $computer.TotalPhysicalMemory / 1GB, 2
)
Write-Host "Installed RAM: $ramGB GB"

# System uptime
$uptime = (Get-Date) - $os.LastBootUpTime
Write-Host "System Uptime: $($uptime.Days) days"

Write-Host ""

# Disk space health check
Write-Host ""
Write-Host "DISK SPACE HEALTH CHECK"
Write-Host "-----------------------"

$disk = Get-CimInstance Win32_LogicalDisk -Filter "DeviceID='C:'"

if ($null -ne $disk -and $disk.Size -gt 0) {
    $totalGB = [math]::Round($disk.Size / 1GB, 2)
    $freeGB = [math]::Round($disk.FreeSpace / 1GB, 2)
    $freePercent = [math]::Round(
        ($disk.FreeSpace / $disk.Size) * 100, 2
    )

    Write-Host "Total Disk Space: $totalGB GB"
    Write-Host "Free Disk Space: $freeGB GB"
    Write-Host "Free Space Percentage: $freePercent%"

    if ($freePercent -lt 15) {
        Write-Host "WARNING: Low disk space!" -ForegroundColor Yellow
    }
    else {
        Write-Host "Disk Space Status: Healthy" -ForegroundColor Green
    }
}
else {
    Write-Host "WARNING: C: drive information unavailable." -ForegroundColor Yellow
}

Write-Host "System information collected successfully."
