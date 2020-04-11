param (
    [string] $GitHubApiKey,
    [string] $ExportFileName,
    [string] $GitHubOrganization,
    [string] $AzureUserPrinciple,
    [securestring] $AzureUserPrincipleSecret,
    [string] $AzureTenant,
    [string] $AzureResourceGroup,
    [string] $AzureApplicationName
)

$env:GitHubApiKey = $GitHubApiKey
Import-module .\Authentication.ps1 -Force

$teams = (Get-Content $ExportFileName | Out-String | ConvertFrom-Json)

foreach ($team in $teams) {
    $repositoryName = "PartsUnlimited-$($team.TeamName)"

    $createdTeam = .\Create-OrganisationTeam.ps1 -TeamName $team.TeamName -OrganizationName $GitHubOrganization
    .\Create-Repo.ps1 -RepositoryName $RepositoryName -OrganizationName $GitHubOrganization -TeamId $createdTeam.Id
    .\Create-AzureResources.ps1 -AzureUserPrinciple $AzureUserPrinciple -AzureUserPrincipleSecret $AzureUserPrincipleSecret -AzureResourceGroup $AzureResourceGroup-$($team.TeamName) -AzureApplicationName $repositoryName -AzureTenantName $AzureTenant -GitHubRepository $RepositoryName -GitHubOrganization $GitHubOrganization
    .\Add-ApplicationNameToYml.ps1 -ApplicationName $repositoryName
    .\Add-CodeToRepo.ps1 -OrganizationName $GitHubOrganization -RepositoryName $RepositoryName
}