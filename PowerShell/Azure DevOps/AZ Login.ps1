# Here's what this PowerShell script does:
# The script defines several variables, including the tenantId, servicePrincipalId, servicePrincipalKey, and subscriptionId.
# These variables should be set to the appropriate values for your Azure account.
# The script uses the ConvertTo-SecureString cmdlet to convert the service principal key to a secure string.
# The script creates a new PSCredential object using the service principal ID and secure key.
# The Connect-AzAccount cmdlet is used to log in to Azure using the service principal credentials.
# The Select-AzSubscription cmdlet is used to select the appropriate subscription.
# You can include this PowerShell script as a task in your Azure DevOps pipeline to authenticate to Azure and execute other Azure CLI or PowerShell commands that require authentication.
# Just make sure to replace the variable values with your own credentials and subscription ID.


# Define variables
$tenantId = "<your tenant ID>"
$servicePrincipalId = "<your service principal ID>"
$servicePrincipalKey = "<your service principal key>"
$subscriptionId = "<your subscription ID>"

# Authenticate using service principal credentials
$azurePassword = ConvertTo-SecureString $servicePrincipalKey -AsPlainText -Force
$azureCredentials = New-Object System.Management.Automation.PSCredential ($servicePrincipalId, $azurePassword)

Connect-AzAccount -ServicePrincipal -Tenant $tenantId -Credential $azureCredentials

Select-AzSubscription -SubscriptionId $subscriptionId
