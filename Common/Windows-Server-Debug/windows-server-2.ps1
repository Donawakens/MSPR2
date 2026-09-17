# 1. Télécharger le script de configuration
$url = "https://raw.githubusercontent.com/ansible/ansible-documentation/devel/examples/scripts/ConfigureRemotingForAnsible.ps1"
$file = "$env:temp\ConfigureRemotingForAnsible.ps1"
(New-Object System.Net.WebClient).DownloadFile($url, $file)

# 2. Exécuter le script sans l'argument posant problème
powershell.exe -ExecutionPolicy Bypass -File $file -CertValidityDays 1095
