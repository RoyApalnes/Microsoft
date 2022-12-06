#Parameters
$SiteURL = "Your Site URL"
$ListName = "Your List Name"
 
#Connect to PnP
$conn = Connect-PnPOnline -url $SiteURL -Interactive
 
#Get the Library
$List = Get-PnPList -Connection $conn $ListName
 
#Exclude List or Library from Sync
$List.ExcludeFromOfflineClient = $true
$List.Update()
Invoke-PnPQuery