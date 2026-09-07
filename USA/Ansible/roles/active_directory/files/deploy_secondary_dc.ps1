param (
    [Parameter(Mandatory=$true)][string]$DomainName,
    [Parameter(Mandatory=$true)][string]$PrimaryDcIp,
    [Parameter(Mandatory=$true)][string]$DomainAdminUser,
    [Parameter(Mandatory=$true)][string]$DomainAdminPassword,
    [Parameter(Mandatory=$true)][string]$DsrmPassword
)

$ErrorActionPreference = "Stop"

# 1. Configuration du DNS principal vers le contrôleur de Londres
$NetAdapter = Get-NetAdapter | Where-Status -eq "Up" | Select-Object -First 1
Set-DnsClientServerAddress -InterfaceIndex $NetAdapter.ifIndex -ServerAddresses ($PrimaryDcIp, "127.0.0.1")

# 2. Installation du rôle AD DS
Install-WindowsFeature -Name AD-Domain-Services -IncludeManagementTools 

# 3. Promotion en contrôleur de domaine secondaire
$SecureAdminPass = ConvertTo-SecureString $DomainAdminPassword -AsPlainText -Force
$Cred = New-Object System.Management.Automation.PSCredential("$DomainName\$DomainAdminUser", $SecureAdminPass)
$SecureDsrmPass = ConvertTo-SecureString $DsrmPassword -AsPlainText -Force

Install-ADDSDomainController `
    -DomainName $DomainName `
    -Credential $Cred `
    -SafeModeAdministratorPassword $SecureDsrmPass `
    -InstallDNS:$true `
    -NoRebootOnCompletion:$false `
    -Force:$true