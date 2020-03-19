param (
    [string] $OrganizationName,
    [string] $TeamSlug,
    [string] $AADEmail
)

$AddCollaboratorGithubUri = "https://api.github.com/orgs/$OrganizationName/teams/$TeamSlug/memberships/$AADEmail";

$Body = @{
    role = "maintainer"
}

$Header = GetBasicAuthenticationHeader

$Response = Invoke-RestMethod -Uri $AddCollaboratorGithubUri -Headers @{Authorization = $Header} -ContentType "application/json" -Method Put -Body (ConvertTo-Json $Body)

Write-Output $Response