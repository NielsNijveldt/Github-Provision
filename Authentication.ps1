function GetBasicAuthenticationHeader(){
    $CredPair = "username:$env:GitHubApiKey"
 
    $EncodedCredentials = [System.Convert]::ToBase64String([System.Text.Encoding]::ASCII.GetBytes($CredPair))
    
    return "Basic $EncodedCredentials";
}