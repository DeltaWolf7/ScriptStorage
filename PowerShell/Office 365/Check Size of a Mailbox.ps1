# Here's what this script does:
# The script first prompts the user to enter the email address of the mailbox they want to check.
# It then connects to Exchange Online using the user's credentials and imports the Exchange Online PowerShell session.
# The script uses the Get-MailboxStatistics cmdlet to retrieve information about the mailbox, including its size.
# The script then outputs the mailbox size in a table format using the Format-Table cmdlet.
# Finally, the script disconnects from Exchange Online.
# Note: You'll need to have the Exchange Online PowerShell module installed on your computer before running this script.


# Connect to Exchange Online
$UserCredential = Get-Credential
$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://outlook.office365.com/powershell-liveid/ -Credential $UserCredential -Authentication Basic -AllowRedirection
Import-PSSession $Session -DisableNameChecking

# Get mailbox size
$Mailbox = Read-Host "Enter mailbox email address"
$Size = Get-MailboxStatistics $Mailbox | Select-Object TotalItemSize
$Size | Format-Table -AutoSize

# Disconnect from Exchange Online
Remove-PSSession $Session
