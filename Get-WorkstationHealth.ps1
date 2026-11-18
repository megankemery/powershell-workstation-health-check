
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
Write-Host "System information collected successfully."
