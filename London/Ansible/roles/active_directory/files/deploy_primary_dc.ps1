param (
    [Parameter(Mandatory=$true)][string]$DomainName,
    [Parameter(Mandatory=$true)][string]$NetbiosName,
    [Parameter(Mandatory=$true)][string]$DsrmPassword
)

$ErrorActionPreference = "Stop"

# 1. Installation du rôle AD DS
Install-WindowsFeature -Name AD-Domain-Services -IncludeManagementTools

# 2. Conversion du mot de passe DSRM
$SecureDsrmPassword = ConvertTo-SecureString $DsrmPassword -AsPlainText -Force

# 3. Déploiement de la forêt AD
Install-ADDSForest `
    -CreateDnsDelegation:$false `
    -DatabasePath "C:\Windows\NTDS" `
    -DomainMode "WinThreshold" `
    -DomainName $DomainName `
    -DomainNetbiosName $NetbiosName `
    -ForestMode "WinThreshold" `
    -InstallDns:$true `
    -LogPath "C:\Windows\NTDS" `
    -NoRebootOnCompletion:$false `
    -SysvolPath "C:\Windows\SYSVOL" `
    -SafeModeAdministratorPassword $SecureDsrmPassword `
    -Force:$true