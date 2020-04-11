param (
    [string] $RepositoryName,
    [string] $OrganizationName,
    [int] $TeamId
)

$CreateRepoGithubUri = "https://api.github.com/orgs/$OrganizationName/repos"

$Body = @{
    name = $RepositoryName
    team_id = $TeamId
}

$Header = GetBasicAuthenticationHeader

$Response = Invoke-RestMethod -Uri $CreateRepoGithubUri -Headers @{Authorization = $Header} -ContentType "application/json" -Method Post -Body (ConvertTo-Json $Body)

$OrganizationId = $Response.organization.id
$Owner = $Response.owner.login
$UpdateTeamPermissions = "https://api.github.com/organizations/$OrganizationId/team/$TeamId/repos/$Owner/$RepositoryName"

$TeamPermissionsBody = @{
    permission = "admin"
}

Invoke-RestMethod -Uri $UpdateTeamPermissions -Headers @{Authorization = $Header} -ContentType "application/json" -Method Put -Body (ConvertTo-Json $TeamPermissionsBody)