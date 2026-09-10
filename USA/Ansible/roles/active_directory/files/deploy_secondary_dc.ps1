param (
    [Parameter(Mandatory=$true)][string]$DomainName,
    [Parameter(Mandatory=$true)][string]$PrimaryDcIp,
    [Parameter(Mandatory=$true)][string]$DomainAdminUser,
    [Parameter(Mandatory=$true)][string]$DomainAdminPassword,
    [Parameter(Mandatory=$true)][string]$DsrmPassword
)

$ErrorActionPreference = "Stop"

# 1. Configuration DNS avec la syntaxe PowerShell correcte
$NetAdapter = Get-NetAdapter | Where-Object Status -eq "Up" | Select-Object -First 1
Set-DnsClientServerAddress -InterfaceIndex $NetAdapter.ifIndex -ServerAddresses ($PrimaryDcIp, "127.0.0.1")

# Vider le cache DNS pour appliquer immédiatement la nouvelle adresse
Clear-DnsClientCache
Start-Sleep -Seconds 5

# 2. Validation préalable de la connectivité vers atp.local
try {
    $DnsResult = Resolve-DnsName -Name $DomainName -Type A -ErrorAction Stop
    Write-Host "DNS résolu avec succès vers : $($DnsResult.IPAddress)"
} catch {
    throw "Impossible de résoudre $DomainName via le DNS $PrimaryDcIp. Vérifiez la connectivité et le pare-feu du PDC."
}

# 3. Installation des fonctionnalités AD DS et outils d'administration
Install-WindowsFeature -Name AD-Domain-Services, RSAT-AD-Tools -IncludeManagementTools

# 4. Promotion en contrôleur de domaine secondaire
$SecureAdminPass = ConvertTo-SecureString $DomainAdminPassword -AsPlainText -Force
$Cred = New-Object System.Management.Automation.PSCredential("$DomainName\$DomainAdminUser", $SecureAdminPass)
$SecureDsrmPass = ConvertTo-SecureString $DsrmPassword -AsPlainText -Force

Install-ADDSDomainController `
    -DomainName $DomainName `
    -Credential $Cred `
    -SafeModeAdministratorPassword $SecureDsrmPass `
    -InstallDNS:$true `
    -NoRebootOnCompletion:$true `
    -Force:$true