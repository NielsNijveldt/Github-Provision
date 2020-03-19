param (
    [string] $TeamName,
    [string] $OrganizationName
)

$CreateRepoGithubUri = "https://api.github.com/orgs/$OrganizationName/teams";

$Body = @{
    name = $TeamName
}

$Header = GetBasicAuthenticationHeader

$Response = Invoke-RestMethod -Uri $CreateRepoGithubUri -Headers @{Authorization = $Header} -ContentType "application/json" -Method Post -Body (ConvertTo-Json $Body)

return $Response
