#
# Windows PowerShell script for AD DS Deployment
#

#Variables
$DatabasePath = "C:\Windows\NTDS"
$DomainMode = "Default"
$DomainName = "itiscloudy.com"
$DomainNetbiosName = "itiscloudy"
$ForestMode = "Default"
$LogPath = "C:\Windows\NTDS"
$SysvolPath ="C:\Windows\SYSVOL"
$Secure_String_Pwd = ConvertTo-SecureString "Auay8idda" -AsPlainText -Force

#Install ADDS
Install-windowsfeature -name AD-Domain-Services -IncludeManagementTools

#Configure ADDS
Import-Module ADDSDeployment

Install-ADDSForest -CreateDnsDelegation:$false -DatabasePath $DatabasePath -DomainMode $DomainMode -DomainName $DomainName -DomainNetbiosName $DomainNetbiosName -ForestMode $ForestMode -InstallDns:$true -LogPath $LogPat -NoRebootOnCompletion:$false -SysvolPath $SysvolPath -Force:$true -Safemodeadministratorpassword $Secure_String_Pwd