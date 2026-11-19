# PowerShell Workstation Health Check

A PowerShell-based IT automation tool that collects
Windows workstation diagnostics, evaluates system
health indicators, and generates a CSV report.

## Project Overview

This project demonstrates how PowerShell can simplify
routine Windows troubleshooting by gathering system
information and identifying potential performance
or connectivity issues.

The tool was developed as a hands-on IT automation
project focused on Windows administration, diagnostic
scripting, reporting, and GitHub Actions.

## Features

- Collects Windows operating system information
- Identifies the computer name and processor
- Reports installed physical memory
- Calculates system uptime
- Measures available disk space
- Warns when disk free space falls below 15%
- Calculates physical memory utilization
- Warns when memory usage reaches 85% or higher
- Identifies active network adapters
- Displays assigned IPv4 addresses
- Tests ICMP connectivity to 1.1.1.1
- Generates a structured CSV health report
- Runs automatically through GitHub Actions
- Provides a downloadable report artifact

## Technologies Used

- **PowerShell** - Windows automation and scripting
- **WMI/CIM** - Windows system information
- **GitHub** - Version control and documentation
- **GitHub Actions** - Windows-based workflow execution
- **CSV** - Structured diagnostic reporting

## Project Structure

```text
powershell-workstation-health-check/
├── .github/
│   └── workflows/
│       └── workstation-health-check.yml
├── Get-WorkstationHealth.ps1
├── sample-health-report.csv
└── README.md
```

## How It Works

1. The script retrieves Windows system information
   using PowerShell and CIM commands.
2. It calculates available disk space and memory usage.
3. It compares those measurements against defined
   warning thresholds.
4. It identifies active network adapters and IPv4
   addresses.
5. It attempts an ICMP connectivity test to 1.1.1.1.
6. It displays diagnostic information in the console.
7. It exports summarized results to a CSV file.
8. GitHub Actions saves the report as a downloadable
   workflow artifact.

## Health Check Thresholds

| Diagnostic | Healthy | Warning |
|---|---|---|
| Disk free space | 15% or higher | Below 15% |
| Memory utilization | Below 85% | 85% or higher |
| Network ICMP test | Successful response | No response |

These thresholds are configurable examples and are
not intended to replace organization-specific
monitoring standards.

## Running the Script

### Run Locally

On a supported Windows computer with PowerShell
and the required Windows networking cmdlets:

```powershell
.\Get-WorkstationHealth.ps1
```

The script generates `workstation-health-report.csv`
in the same directory as the script.

The script is designed to collect diagnostic
information without changing system settings.

### Run Using GitHub Actions

1. Open the repository in GitHub.
2. Select the **Actions** tab.
3. Choose **PowerShell Workstation Health Check**.
4. Click **Run workflow**.
5. Select the `main` branch.
6. Wait for the workflow to complete.
7. Download the `workstation-health-report` artifact.

GitHub Actions runs the script on a temporary
Windows runner, not on the user's local computer.

## Testing and Results

The script was successfully executed through
GitHub Actions on a Windows Server 2025 runner.

The workflow verified that the script could:

- Retrieve Windows system information
- Calculate disk space availability
- Calculate physical memory utilization
- Evaluate disk and memory warning thresholds
- Execute network diagnostic commands
- Generate a CSV report
- Upload the report as a downloadable artifact

### Observed Test Results

| Diagnostic | Result |
|---|---|
| Operating system | Windows Server 2025 Datacenter |
| Windows build | 26100 |
| Installed RAM | 15.99 GB |
| Disk free space | Approximately 20% |
| Disk status | Healthy |
| Memory usage | 15.88% |
| Memory status | Healthy |
| Network ICMP test | Failed |

The workflow completed successfully and generated
a CSV report containing all 14 expected columns.

A sanitized example is available in
`sample-health-report.csv`.

## Network Diagnostic Limitations

The network connectivity check uses ICMP packets
to test reachability to 1.1.1.1.

A failed ICMP test does not necessarily indicate
a complete internet outage. Firewalls, network
policies, and cloud runner restrictions may block
ICMP traffic.

During testing, the GitHub runner reported a
failed connectivity test while the overall
PowerShell workflow completed successfully.

Future improvements may include separate DNS
resolution and HTTPS connectivity checks.

## Enhanced Network Connectivity Testing

The workstation health check uses two separate
network diagnostics to provide more meaningful
troubleshooting information.

### ICMP Connectivity Test

The script uses `Test-Connection` to check whether
1.1.1.1 responds to ICMP echo requests.

A failed ICMP test does not necessarily indicate
an internet outage because ICMP traffic may be
blocked or filtered by network security policies.

### HTTPS Connectivity Test

The script uses `Invoke-WebRequest` to test
HTTPS connectivity to https://www.microsoft.com.

This provides an additional indication of whether
the workstation can reach a public website.

### Verified Test Results

During GitHub Actions testing, the Windows runner
produced the following results:

| Diagnostic | Result |
|---|---|
| ICMP connectivity | Failed |
| HTTPS connectivity | Successful |
| GitHub Actions workflow | Successful |
| CSV report generation | Successful |

These results demonstrate that HTTPS connectivity
can succeed even when an ICMP test fails.

The reason for the failed ICMP test was not
determined, so it should not be attributed to
a specific firewall or network policy.

### CSV Report Enhancement

The generated workstation health report now
contains 15 columns, including:

- `NetworkStatus` - ICMP connectivity result
- `HTTPSStatus` - HTTPS connectivity result

Both results are included in the downloadable
GitHub Actions report artifact.

A fictional example of the updated report is
available in `sample-health-report.csv`.

### Troubleshooting Skills Demonstrated

- Comparing multiple network diagnostic methods
- Understanding ICMP versus HTTPS connectivity
- Interpreting network test limitations
- Updating PowerShell reporting functionality
- Verifying CSV output
- Testing changes through GitHub Actions

## Skills Demonstrated

### Windows Administration
- PowerShell scripting
- Windows system diagnostics
- WMI/CIM queries
- Disk and memory monitoring
- Network troubleshooting fundamentals

### Automation and Reporting
- Conditional logic
- Calculations and thresholds
- PowerShell custom objects
- CSV report generation
- Automated workflow execution

### Development Practices
- GitHub version control
- GitHub Actions configuration
- Workflow troubleshooting
- Output verification
- Technical documentation
- Sanitized sample data

## Security and Privacy

This project is intended for educational and
portfolio demonstration purposes.

The script is read-only and does not intentionally
modify system settings, user accounts, or files
other than its generated CSV report.

Diagnostic output may contain computer names,
network addresses, and system configuration details.

Reports collected from real workplace devices
should not be published in a public repository
without authorization and appropriate sanitization.

## Future Improvements

- Add DNS resolution testing
- Add HTTPS connectivity checks
- Improve error handling for unavailable system data
- Add configurable warning thresholds
- Generate an HTML dashboard
- Add automated PowerShell tests
- Support remote workstation diagnostics
  in authorized environments

## Career Development

This project demonstrates practical PowerShell
automation skills that complement experience
in IT help desk support and Windows troubleshooting.

It showcases the ability to collect diagnostic
information, evaluate system health indicators,
generate structured reports, and automate
execution using GitHub Actions.

The project supports continued development
toward advanced technical support, Windows
systems administration, and IT automation roles.
