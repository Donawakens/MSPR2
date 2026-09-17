# Autoriser l'authentification Basic pour le client et le serveur WinRM
Set-Item -Path "WSMan:\localhost\Service\Auth\Basic" -Value $true
Set-Item -Path "WSMan:\localhost\Service\AllowUnencrypted" -Value $true

# Créer la règle pour autoriser le flux WinRM HTTPS entrant
New-NetFirewallRule -Name "WinRM-HTTPS-In" -DisplayName "WinRM HTTPS (Ansible)" -Enabled True -Direction Inbound -Protocol TCP -LocalPort 5986 -Action Allow


# 1. Créer un certificat auto-signé
$cert = New-SelfSignedCertificate -DnsName $env:COMPUTERNAME -CertStoreLocation "Cert:\LocalMachine\My"

# 2. Supprimer les anciens écouteurs HTTPS s'ils existent
Remove-Item -Path "WSMan:\Localhost\listener\listener*" -Recurse -ErrorAction SilentlyContinue

# 3. Créer le nouvel écouteur HTTPS sur le port 5986
New-Item -Path "WSMan:\Localhost\Listener" -Transport HTTPS -Address * -CertificateThumbPrint $cert.Thumbprint -Force

# 4. Redémarrer le service WinRM
Restart-Service WinRM

Get-ChildItem -Path WSMan:\Localhost\Listener
