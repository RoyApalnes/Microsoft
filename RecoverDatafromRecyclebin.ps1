#Parameter
$SiteURL= “https://yourDomain.sharepoint.com/sites/yoursiteName”
 
#Connect to PnP Online
#Connect-PnPOnline -Url $SiteURL -Credentials (Get-Credential)
$conn = Connect-PnPOnline -Url $SiteURL -Interactive
$Web = Get-PnPWeb
(Get-PnPRecycleBinItem -Connection $conn).count
 
#Get All Items Deleted in the Past 2 Days
$DeletedItems = Get-PnPRecycleBinItem -Connection $conn -RowLimit 500000 | Where { $_.DeletedDate -gt (Get-Date).AddDays(-2) }
#To edit the deleted files list
#$DeletedItems | Export-Csv Deleteditems.csv
#$DeletedItems | Import-Csv Deleteditems.csv
#Restore Recycle bin items matching given query
$DeletedItems | Restore-PnpRecycleBinItem -Connection $conn -RowLimit 500000 -Force