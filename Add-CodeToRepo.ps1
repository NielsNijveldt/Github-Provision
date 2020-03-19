param (
    [string] $OrganizationName,
    [string] $RepositoryName
)

$CreateRepoGithubUri = "https://api.github.com/repos/$OrganizationName/$RepositoryName";

$CurrentLocation = Get-Location
$TempDirectory = "C:\temp\$RepositoryName"
$PartsUnlimitedDirectory = "$CurrentLocation\PartsUnlimited"
$GithubActionsDirectory = "$CurrentLocation\GithubActions"

$Header = GetBasicAuthenticationHeader

$Response = Invoke-RestMethod -Uri $CreateRepoGithubUri -Headers @{Authorization = $Header} -ContentType "application/json" -Method Get -Body (ConvertTo-Json $Body)

$GitUrl = $Response.clone_url

New-Item $TempDirectory -ItemType Directory
Push-Location $TempDirectory
git clone $GitUrl .

# TODO: Clone files from source repo -> Copy to destination -> Commit to target repo
Copy-Item -Recurse -Path "$PartsUnlimitedDirectory\*" -Destination $TempDirectory -Force
Copy-Item -Recurse -Path "$GithubActionsDirectory" -Destination "$TempDirectory\.github\workflows" -Force 

git add .
git commit -m "Init commit"
git push
Pop-Location

Remove-Item "$TempDirectory" -Recurse -Force -ErrorAction Ignore