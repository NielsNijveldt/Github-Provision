param (
    [string] $AzureUserPrinciple,
    [securestring] $AzureUserPrincipleSecret,
    [string] $AzureTenantName,
    [string] $AzureResourceGroup,
    [string] $AzureApplicationName,
    [string] $GitHubOrganization,
    [string] $GitHubRepository
)

$PlanName = 'BasicPlan'

$Credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $AzureUserPrinciple, $AzureUserPrincipleSecret
$LoginDetails = (az login --service-principal -u $Credential.UserName -p $Credential.GetNetworkCredential().Password --tenant $AzureTenantName) | ConvertFrom-Json
az group create -l westeurope -n $AzureResourceGroup
az appservice plan create -g $AzureResourceGroup -n $PlanName
az webapp create -g $AzureResourceGroup -p $PlanName -n $AzureApplicationName

#$PublishProfile = az webapp deployment list-publishing-profiles -n $azApplicationName -g $AzureResourceGroup
$SubscriptionId = $LoginDetails.id
$AzureCredentials = az ad sp create-for-rbac --name https://$AzureApplicationName --role contributor --scopes /subscriptions/$SubscriptionId/resourceGroups/$AzureResourceGroup --sdk-auth

.\Create-GithubSecret.ps1 -OrganizationName $GitHubOrganization -RepositoryName $GitHubRepository -SecretId 'AZURE_CREDENTIALS' -Secret $AzureCredentials