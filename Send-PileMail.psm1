#Author: Roy Apalnes
#Author Mail: roy.apalnes@gmail.com
#Author Twitter: @royapalnes
#Author Blog: itiscloudy.com
#Contributor: Simon Wåhlin, Christian Knarvik

Function Send-PileMail
{
    [cmdletbinding()]
    Param
    (
        [Parameter(Mandatory,ValueFromPipeline)]
        [String[]]
        $SamAccountName,

        [Parameter(Mandatory,ValueFromPipelineByPropertyName)]
        [ValidateScript({Test-Path $_})]
        [String]
        $Path,
        
        [Parameter(Mandatory,ValueFromPipelineByPropertyName)]
        [String]
        $SmtpServer,
        
        [Parameter(Mandatory,ValueFromPipelineByPropertyName)]
        [String]
        $From,
        
        [Parameter(Mandatory,ValueFromPipelineByPropertyName)]
        [Int]
        $Count
    )
    Begin
    {
        #Commands we run one time
    }
    Process
    {
        ForEach ($Name in $SamAccountName)
        {
            #Commands we run once per user
            $ADUser = Get-ADUser -Filter {samAccountName -eq $Name} -Property mail
            if(-Not([String]::IsNullOrEmpty($ADUser.Mail)))
            {
                $mail = $ADUser.Mail
                for($i=1;$i-le$Count;$i++)
                {
                    # Commands we run $Count times per user
                    Write-Progress -Activity ('Processing user: {0}' -f $ADUser.sAMAccountName) -Id 1 -PercentComplete ($i/$Count*100)
                    Send-MailMessage -SmtpServer $SmtpServer -To $mail -From $From -Subject "Piling up Mail #$i" -Body 'MyBody' -Attachments $file
                }
                Write-Progress -Activity ('Processing user: {0}' -f $ADUser.sAMAccountName) -Id 1 -Completed
            }
            else
            {
                Write-Warning -Message ('User: [{0}] does not have email populated.' -f $ADUser.sAMAccountName)
            }
        }
    }
    End
    {
        #Commands we run when Script is ending
    }
} 

# Pre-set Variables:
# 'user1','user2','user3' | Send-PileMail -Path 'D:\Temp\File.txt' -SmtpServer '192.168.0.10' -From 'roy.apalnes@itiscloudy.com' -Count 330

# Asks for Variables:
# Send-PileMail