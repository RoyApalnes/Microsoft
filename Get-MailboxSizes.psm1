Function Get-MailboxSizes

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
         #Collect DisplayName and TotalItemSize for each $Mailbox, defined by UPN, in $MailboxUsers.
         $Stats = foreach($Mailbox in $MailboxUsers)
        {
            #Get DisplayName and TotalItemSize
            Get-MailboxStatistics -Identity $Mailbox.UserPrincipalName | Select-Object DisplayName,TotalItemSize
        }
        
        #Export Data to CSV
        $Stats | Export-Csv D:\Temp\Product\Report3.csv
    }
    End
    {
        #Commands we run when Script is ending
    }
} 