PowerShell

#Import MS Online Services PowerShell Module
Import-Module MSOnline

#Collect Global Administrator Credentials
$cred = Get-Credential

#CommonName
$cn = “Roy KF”

#Import-Module ActiveDirectory
Import-Module ActiveDirectory
 
#Get the AD User ObjectGUID
$guid = (get-aduser -f {cn -eq $cn} -pr objectguid).objectguid
 
#Get the AD User UPN (matching the Azure AD User Object UPN)
$upn = (get-aduser -f {cn -eq $cn}).userprincipalname
 
#Convert the ObjectGUID into a ImmuteableID
$ImmutableID = [System.Convert]::ToBase64String($guid.ToByteArray())

#Connect to MS Online Service
Connect-MsolService -Credential $cred

#Set the ImmuteableID to the Azure AD User Object
set-msolUser -userprincipalname $upn -immutableID $ImmutableID