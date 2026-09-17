# ==============================================================================
# SCRIPT INITIALISATION ACTIVE DIRECTORY - ATP INFRASTRUCTURE
# À exécuter en tant qu'Administrateur sur le Contrôleur de Domaine
# ==============================================================================

Import-Module ActiveDirectory

# 1. Récupération du domaine courant
$DomainDN = (Get-ADDomain).DistinguishedName
Write-Host "Initialisation de l'AD sur le domaine : $DomainDN" -ForegroundColor Green

# 2. Définition de la structure des Unités d'Organisation (OU)
$OUs = @(
    "OU=ATP_Societe,$DomainDN",
    "OU=Services,OU=ATP_Societe,$DomainDN",
    "OU=IT,OU=Services,OU=ATP_Societe,$DomainDN",
    "OU=Arbitrage,OU=Services,OU=ATP_Societe,$DomainDN",
    "OU=Sites,OU=ATP_Societe,$DomainDN",
    "OU=Londres,OU=Sites,OU=ATP_Societe,$DomainDN",
    "OU=Monaco,OU=Sites,OU=ATP_Societe,$DomainDN",
    "OU=USA,OU=Sites,OU=ATP_Societe,$DomainDN",
    "OU=Sydney,OU=Sites,OU=ATP_Societe,$DomainDN",
    "OU=Groupes,OU=ATP_Societe,$DomainDN"
)

# Création des OU
foreach ($OU in $OUs) {
    if (-not (Get-ADOrganizationalUnit -Filter "DistinguishedName -eq '$OU'")) {
        New-ADOrganizationalUnit -Path ($OU -split ',', 2)[1] -Name (($OU -split '=')[1] -split ',')[0] -ProtectedFromAccidentalDeletion $false
        Write-Host "OU créée : $OU" -ForegroundColor Cyan
    }
}

# 3. Création des Groupes de Sécurité
$GroupOU = "OU=Groupes,OU=ATP_Societe,$DomainDN"
$Groups = @(
    @{Name="GRP_IT_DevOps"; Scope="Global"; Category="Security"},
    @{Name="GRP_Staff_Arbitral"; Scope="Global"; Category="Security"},
    @{Name="GRP_Nomades_RDP"; Scope="Global"; Category="Security"}
)

foreach ($Group in $Groups) {
    if (-not (Get-ADGroup -Filter "Name -eq '$($Group.Name)'")) {
        New-ADGroup -Name $Group.Name -GroupScope $Group.Scope -GroupCategory $Group.Category -Path $GroupOU
        Write-Host "Groupe créé : $($Group.Name)" -ForegroundColor Yellow
    }
}

# 4. Liste des utilisateurs à intégrer
$PasswordSec = ConvertTo-SecureString "Adminadmin1234!" -AsPlainText -Force

$Users = @(
    # Équipe IT / DevOps (Londres)
    @{
        FirstName="Kevin"; LastName="DevOps"; SamAccountName="kdevops"; 
        OU="OU=IT,OU=Services,OU=ATP_Societe,$DomainDN"; 
        Group="GRP_IT_DevOps"; UPN="kdevops@atp.local"; Title="Ingénieur DevOps"
    },
    @{
        FirstName="Charlelie"; LastName="SysAdmin"; SamAccountName="csysadmin"; 
        OU="OU=IT,OU=Services,OU=ATP_Societe,$DomainDN"; 
        Group="GRP_IT_DevOps"; UPN="csysadmin@atp.local"; Title="Administrateur Système"
    },
    # Staff Arbitral (Nomades / Bureaux Virtuels)
    @{
        FirstName="John"; LastName="Ref"; SamAccountName="jreferee"; 
        OU="OU=Arbitrage,OU=Services,OU=ATP_Societe,$DomainDN"; 
        Group="GRP_Staff_Arbitral"; UPN="jreferee@atp.local"; Title="Juge Arbitre"
    },
    @{
        FirstName="Maria"; LastName="Supervisor"; SamAccountName="msupervisor"; 
        OU="OU=Arbitrage,OU=Services,OU=ATP_Societe,$DomainDN"; 
        Group="GRP_Staff_Arbitral"; UPN="msupervisor@atp.local"; Title="Superviseur Tournoi"
    }
)

# 5. Création et affectation des utilisateurs
foreach ($User in $Users) {
    if (-not (Get-ADUser -Filter "SamAccountName -eq '$($User.SamAccountName)'")) {
        # Création de l'utilisateur Active Directory
        New-ADUser `
            -GivenName $User.FirstName `
            -Surname $User.LastName `
            -DisplayName "$($User.FirstName) $($User.LastName)" `
            -SamAccountName $User.SamAccountName `
            -UserPrincipalName $User.UPN `
            -Title $User.Title `
            -Path $User.OU `
            -AccountPassword $PasswordSec `
            -Enabled $true `
            -PasswordNeverExpires $true `
            -ChangePasswordAtLogon $false

        # Ajout aux groupes de sécurité
        Add-ADGroupMember -Identity $User.Group -Members $User.SamAccountName
        
        # Ajout systématique au groupe des nomades/RDP
        Add-ADGroupMember -Identity "GRP_Nomades_RDP" -Members $User.SamAccountName

        Write-Host "Utilisateur créé et configuré : $($User.SamAccountName)" -ForegroundColor Green
    } else {
        Write-Host "L'utilisateur $($User.SamAccountName) existe déjà." -ForegroundColor Gray
    }
}

Write-Host "`nInitialisation de l'Active Directory terminée avec succès !" -ForegroundColor Green
