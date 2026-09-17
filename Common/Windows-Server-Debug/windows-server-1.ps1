# Vérifier / Créer l'utilisateur local ansible avec le bon mot de passe
$Password = ConvertTo-SecureString "Adminadmin1234" -AsPlainText -Force
New-LocalUser -Name "ansible" -Password $Password -AccountNeverExpires -ErrorAction SilentlyContinue
Set-LocalUser -Name "ansible" -Password $Password

# S'assurer qu'il appartient au groupe Administrateurs
Add-LocalGroupMember -Group "Administrateurs" -Member "ansible" -ErrorAction SilentlyContinue
# Version anglophone si OS en anglais :
Add-LocalGroupMember -Group "Administrators" -Member "ansible" -ErrorAction SilentlyContinue
