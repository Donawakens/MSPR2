Import-Module ActiveDirectory
Get-ADUser -Filter * | Select-Object Name, SamAccountName, Enabled


Get-ADUser -Filter * | Select-Object Name, SamAccountName, Enabled
