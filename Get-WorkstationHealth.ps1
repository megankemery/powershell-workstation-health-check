
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

# Memory utilization health check
Write-Host ""
Write-Host "MEMORY HEALTH CHECK"
Write-Host "-------------------"

$totalMemoryKB = $os.TotalVisibleMemorySize
$freeMemoryKB = $os.FreePhysicalMemory

if ($totalMemoryKB -gt 0) {
    $usedMemoryKB = $totalMemoryKB - $freeMemoryKB

    $usedMemoryPercent = [math]::Round(
        ($usedMemoryKB / $totalMemoryKB) * 100, 2
    )

    $availableMemoryGB = [math]::Round(
        $freeMemoryKB / 1MB, 2
    )

    Write-Host "Available RAM: $availableMemoryGB GB"
    Write-Host "Memory Usage: $usedMemoryPercent%"

    if ($usedMemoryPercent -ge 85) {
        Write-Host "WARNING: High memory usage!" -ForegroundColor Yellow
    }
    else {
        Write-Host "Memory Status: Healthy" -ForegroundColor Green
    }
}
else {
    Write-Host "WARNING: Memory information unavailable." -ForegroundColor Yellow
}

# Network connectivity health check
Write-Host ""
Write-Host "NETWORK HEALTH CHECK"
Write-Host "--------------------"

# Find active network adapters
$adapters = Get-NetAdapter |
    Where-Object { $_.Status -eq "Up" }

if ($adapters) {
    foreach ($adapter in $adapters) {
        Write-Host "Adapter: $($adapter.Name)"
        Write-Host "Status: $($adapter.Status)"

        # Retrieve IPv4 configuration
        $ipAddresses = Get-NetIPAddress `
            -InterfaceIndex $adapter.ifIndex `
            -AddressFamily IPv4 `
            -ErrorAction SilentlyContinue

        foreach ($ip in $ipAddresses) {
            Write-Host "IPv4 Address: $($ip.IPAddress)"
        }
    }
}
else {
    Write-Host "WARNING: No active network adapters found!" `
        -ForegroundColor Yellow
}

# Test outbound network connectivity
Write-Host ""
Write-Host "Testing connectivity to 1.1.1.1..."

$connection = Test-Connection `
    -ComputerName "1.1.1.1" `
    -Count 2 `
    -Quiet `
    -ErrorAction SilentlyContinue

if ($connection) {
    Write-Host "Network Connectivity: Successful" `
        -ForegroundColor Green
}
else {
    Write-Host "WARNING: Connectivity test failed!" `
        -ForegroundColor Yellow
}

Write-Host "System information collected successfully."

# Generate workstation health report
Write-Host ""
Write-Host "GENERATING HEALTH REPORT"
Write-Host "------------------------"

# Set report location
$reportPath = Join-Path $PSScriptRoot "workstation-health-report.csv"

# Determine disk status
$diskStatus = "Unknown"

if ($null -ne $disk -and $disk.Size -gt 0) {
    if ($freePercent -lt 15) {
        $diskStatus = "Low Disk Space"
    }
    else {
        $diskStatus = "Healthy"
    }
}

# Determine memory status
$memoryStatus = "Unknown"

if ($totalMemoryKB -gt 0) {
    if ($usedMemoryPercent -ge 85) {
        $memoryStatus = "High Memory Usage"
    }
    else {
        $memoryStatus = "Healthy"
    }
}

# Determine network status
$networkStatus = "Connectivity Test Failed"

if ($connection) {
    $networkStatus = "Successful"
}

# Build the report
$report = [PSCustomObject]@{
    ReportDate = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    ComputerName = $env:COMPUTERNAME
    OperatingSystem = $os.Caption
    WindowsBuild = $os.BuildNumber
    Processor = $processor.Name
    InstalledRAM_GB = $ramGB
    SystemUptime_Days = $uptime.Days
    DiskTotal_GB = $totalGB
    DiskFree_GB = $freeGB
    DiskFree_Percent = $freePercent
    DiskStatus = $diskStatus
    MemoryUsed_Percent = $usedMemoryPercent
    MemoryStatus = $memoryStatus
    NetworkStatus = $networkStatus
}

# Export results to CSV
$report | Export-Csv `
    -Path $reportPath `
    -NoTypeInformation `
    -Encoding UTF8

Write-Host "Health report generated successfully!"
Write-Host "Report saved to: $reportPath"
