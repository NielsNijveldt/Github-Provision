param (
    [string] $TeamName,
    [string] $OrganizationName
)

$Header = GetBasicAuthenticationHeader

$CreateRepoGithubUri = "https://api.github.com/orgs/$OrganizationName/teams";

$Body = @{
    name = $TeamName
}

$TeamResponse = Invoke-RestMethod -Uri $CreateRepoGithubUri -Headers @{Authorization = $Header} -ContentType "application/json" -Method Post -Body (ConvertTo-Json $Body)

$AzureGroupsUri = "https://api.github.com/orgs/$OrganizationName/team-sync/groups";

$Response = Invoke-RestMethod -Uri $AzureGroupsUri -Headers @{Authorization = $Header} -ContentType "application/json" -Method Get
$AzureGroup = @($Response.groups | Where-Object {$_.group_name -eq $TeamName})

$TeamSlug = $TeamResponse.slug
$GroupMappingUri = "https://api.github.com/orgs/$OrganizationName/teams/$TeamSlug/team-sync/group-mappings";
$GroupsMappingBody = @{
    groups = $AzureGroup
}
$Response = Invoke-RestMethod -Uri $GroupMappingUri -Headers @{Authorization = $Header} -ContentType "application/json" -Method Patch -Body (ConvertTo-Json $GroupsMappingBody)


return $TeamResponse