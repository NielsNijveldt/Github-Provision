param (
    [string] $OrganizationName,
    [string] $RepositoryName,
    [string] $SecretId,
    [string] $Secret
)

$GetPublicKeyGithubUri = "https://api.github.com/repos/$OrganizationName/$RepositoryName/actions/secrets/public-key";

$Header = GetBasicAuthenticationHeader

$Response = Invoke-RestMethod -Uri $GetPublicKeyGithubUri -Headers @{Authorization = $Header} -ContentType "application/json" -Method Get
$PublicKey = $Response.key
$PublicKeyId = $Response.key_id

$PublicKeyBytes = [System.Convert]::FromBase64String($PublicKey)

$CurrentPath = Get-Location
Add-Type -Path "$CurrentPath\Sodium\Sodium.dll"
$EncryptedMessageBytes = [Sodium.SealedPublicKeyBox]::Create($Secret, $PublicKeyBytes)
$EncryptedMessage = [System.Convert]::ToBase64String($EncryptedMessageBytes)

$AddSecretGithubUri = "https://api.github.com/repos/$OrganizationName/$RepositoryName/actions/secrets/$SecretId";

$Body = @{
    encrypted_value = $EncryptedMessage
    key_id = $PublicKeyId
}

Invoke-RestMethod -Uri $AddSecretGithubUri -Headers @{Authorization = $Header} -ContentType "application/json" -Method Put -Body (ConvertTo-Json $Body)