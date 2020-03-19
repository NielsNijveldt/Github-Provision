param (
    [string] $RepositoryName,
    [string] $OrganizationName,
    [int] $TeamId
)

$CreateRepoGithubUri = "https://api.github.com/orgs/$OrganizationName/repos";

$Body = @{
    name = $RepositoryName
    team_id = $TeamId
}

$Header = GetBasicAuthenticationHeader

$Response = Invoke-RestMethod -Uri $CreateRepoGithubUri -Headers @{Authorization = $Header} -ContentType "application/json" -Method Post -Body (ConvertTo-Json $Body)

return $Response
