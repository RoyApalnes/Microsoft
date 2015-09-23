$SearchBase = 'OU=Vanlige Brukere,OU=Produksjonsystemer,OU=Brukere,OU=Hands,DC=hands,DC=no'

$AllUsers = Get-ADUser -LDAPFilter '(Mail=*)' -SearchBase $SearchBase -Properties UserPrincipalName

$Allusers | Select SamAccountName | Export-Csv "C:\mid\test.csv"

Import-CSV "C:\mid\test.csv" | % { Add-ADGroupMember -Identity S-Azure-Password-Reset-License $_.SamAccountName }