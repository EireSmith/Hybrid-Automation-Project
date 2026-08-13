# healthcheck.ps1
$nodes = @('3.84.184.198', '100.55.18.200', '44.213.126.18')
$sshUser = 'ubuntu'
$keyPath = "C:\Users\admin\Documents\Software\Powershell Linux nodes\ServerKeyPair.pem"
$results = foreach ($node in $nodes) {
 try {
 $disk = Invoke-Command -HostName $node -UserName $sshUser -KeyFilePath $keyPath -ScriptBlock { df -h / | tail -1 }
 $uptime = Invoke-Command -HostName $node -UserName $sshUser -KeyFilePath $keyPath -ScriptBlock { uptime -p }
 $sshd = Invoke-Command -HostName $node -UserName $sshUser -KeyFilePath $keyPath -ScriptBlock { systemctl is-active sshd }
 [PSCustomObject]@{
 Node = $node
 DiskUsage = $disk
 Uptime = $uptime
 SshService = $sshd
 Status = 'OK'
 }
 }
 catch {
 [PSCustomObject]@{
 Node = $node
 DiskUsage = 'N/A'
 Uptime = 'N/A'
 SshService = 'N/A'
 Status = "FAILED: $($_.Exception.Message)"
 }
 }
}
$results | Format-Table -AutoSize
$results | Export-Csv -Path ./healthcheck-report.csv -NoTypeInformation