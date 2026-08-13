param(
 [string]$NewUser = 'appsvc',
 [string[]]$Nodes = @('3.89.55.54', '54.227.18.152', '98.92.63.3')
)

$sshUser = 'ubuntu'
$keyPath = "C:\Users\admin\Documents\Software\Powershell Linux nodes\ServerKeyPair.pem"

foreach ($node in $Nodes) 
{
 Write-Host "Provisioning $NewUser on $node..."
 try {
 Invoke-Command -HostName $node -UserName $sshUser -KeyFilePath $keyPath -ScriptBlock {param($u)
 if (-not (id -u $u 2>$null)) {
 sudo useradd -m -s /bin/bash $u
 Write-Output "Created user $u"
 } else {
 Write-Output "User $u already exists"
 }
 } -ArgumentList $NewUser
 }
 catch {
 Write-Warning "Failed on ${node}: $($_.Exception.Message)"
 }
}