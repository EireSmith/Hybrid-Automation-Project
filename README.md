# Hybrid-Automation-Project

A couple of PowerShell 7 scripts for managing a small group of Linux EC2 instances over SSH using PowerShell Invoke-Command -HostName remoting commands.

Requirements
PowerShell 7+ 
SSH access to the target nodes with a key pair 
OpenSSH client installed on the machine running the scripts
Scripts

![EC2 Instances](screenshots/New%20instances.png)  
*Initial EC2 Setup"*



 
## healthcheck.ps1

Connects to each node in $nodes and pulls back:

Disk usage (df -h /)
Uptime
SSH service status (systemctl is-active sshd)

Results are printed to the console as a table and exported to healthcheck-report.csv.

Run it with:

powershell
pwsh -File .\healthcheck.ps1

If a node is unreachable, it's still included in the output with a Status of FAILED and the error message.

## provision-user.ps1

Creates a service account (default: appsvc) on each node in $Nodes, if it doesn't already exist.

Run it with:

powershell
pwsh -File .\provision-user.ps1

Or with your own user/node list:

powershell
pwsh -File .\provision-user.ps1 -NewUser "deploysvc" -Nodes "nodex-ip","nodey-ip"

The script checks for the user with id -u before creating it, so it's safe to run more than once. existing users are skipped.

## Setup notes

Both scripts have $nodes / $Nodes and $keyPath hardcoded near the top so edit before running. Node IPs will change if instances are stopped/started or replaced, so this list needs to be kept up to date.(I had issues with rotating IP addresses after reboot so be careful. Also make sure your own IP is up to date. Do not use your mobile hotspot as carriers use CGNAT making your visible IP unreliable.)

## Example output

healthcheck.ps1:

Node            DiskUsage                              Uptime                 SshService Status
----            ---------                              ------                 ---------- ------
1.2.3.4    /dev/root       6.8G  2.8G  4.0G  41% / up 2 hours, 6 minutes active   OK
5.6.7.8   /dev/root       6.8G  2.8G  4.0G  42% / up 2 hours, 7 minutes active   OK
9.10.11.12   /dev/root    6.7G  2.5G  4.2G  38% / up 20 minutes         active     OK

provision-user.ps1:

Provisioning appsvc on 1.2.3.4  ...
Created user appsvc
Provisioning appsvc on 5.6.7.8 ...
Created user appsvc
Provisioning appsvc on 9.10.11.12...
Created user appsvc

Running it again afterwards just reports User appsvc already exists for each node.
