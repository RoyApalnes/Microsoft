#$ExcludeFile = 'C:\Downloads\UPN\Rooms.txt'
$SearchBase = 'OU=Vanlige Brukere,OU=Produksjonsystemer,OU=Brukere,OU=Hands,DC=hands,DC=no'

# Get all users with a mail address in SearchBase:
$AllUsers = Get-ADUser -LDAPFilter '(Mail=*)' -SearchBase $SearchBase -Properties UserPrincipalName,Mail

# Add all but the first user to excludefile
#$AllUsers | Select -ExpandProperty distinguishedName -Skip 1 | out-file $ExcludeFile

# Create empty hashtable
$Exclude = @{}

# Import all entries from ExcludeFile to hashtable
#Get-Content -Path $ExcludeFile | ForEach-Object {$Exclude.Add($_,'')}

# Filter AllUsers
$Filtered = $AllUsers | Where-Object {-Not ($Exclude.ContainsKey($_.mail))}

# Return count of all users:
@($AllUsers).Count
# Return cound of filtered users:
# (Thish should be 1)
@($Filtered).Count

#Export Output to CSV-files
$Filtered | Select Mail | Export-Csv 'C:\mid\UPN\filt.csv'
$AllUsers | Select Mail | Export-Csv 'C:\mid\UPN\all.csv'
$Exclude.Keys | Export-Csv 'C:\mid\UPN\excludefile.csv'
$Exclude.GetEnumerator() | Select -ExpandProperty Key | out-file -FilePath 'C:\mid\UPN\excludefile.csv'

#Take Backup of Old UPN Values
$BackupTable = @{}
$AllUsers | ForEach-Object {$BackupTable.Add($_.DistinguishedName,$_.UserPrincipalName)}
$BackupTable | Export-Clixml -Path C:\mid\UPN\UPNBackup.xml

#Change UPN with Mail
$Filtered | ForEach-Object {Set-ADObject -Identity $_.DistinguishedName -Replace @{UserPrincipalName=$($_.Mail)}}