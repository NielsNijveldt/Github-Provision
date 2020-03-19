# Provision a web application in GitHub with automatic deployment to Azure

## Usage:
.\Provision.ps1 -GitHubApiKey <APIKEY> -ExportFileName .\Teams.json -GitHubOrganization Niels1Test -AzureUserPrinciple api://AzureServicePrinciple -AzureUserPrincipleSecret $password -AzureResourceGroup ProvisionTest -AzureApplicationName PartsUnlimited -AzureTenant domain.com

$password should be a [securestring](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.security/convertto-securestring?view=powershell-7)