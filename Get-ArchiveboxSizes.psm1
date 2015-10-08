Function Get-ArchiveMailboxSizes

{
    [cmdletbinding()]
    Param
    (
    
    )
    Begin
    {
        #Commands we run one time
        #Collect all Mailbox Objects
        $MailboxUsers = Get-Mailbox -ResultSize Unlimited
    }
    Process
    {
         #Collect DisplayName and TotalItemSize for each $Mailbox, defined by UPN, in $MailboxUsers
         $Stats = foreach($Mailbox in $MailboxUsers)
        {
            #
            Get-MailboxStatistics -Identity $Mailbox.UserPrincipalName -Archive | Select-Object DisplayName,TotalItemSize
        }

        #Export Data to CSV
        $Stats | Export-Csv D:\Temp\Product\ReportArchive.csv
    }
    End
    {
        #Commands we run when Script is ending
    }
} 