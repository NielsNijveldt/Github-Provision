param (
    [string] $ApplicationName
)

$CurrentPath = Get-Location
$FullFileName = "$CurrentPath\GithubActions\dotnetcore.yml"
(Get-Content $FullFileName).replace('{{ApplicationNamePlaceHolder}}', $ApplicationName) | Set-Content $FullFileName