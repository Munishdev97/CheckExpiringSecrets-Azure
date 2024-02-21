Connect-AzureAD

# Specify filter for service principal (optional)
$filter = "displayName eq 'your-service-principal-name'"

# Get all service principals (or filtered)
$servicePrincipals = Get-AzureADServicePrincipal -Filter $filter

# Loop through each service principal
foreach ($sp in $servicePrincipals) {
  # Get certificate credentials
  $credentials = Get-AzureADServicePrincipalCredential -ObjectId $sp.ObjectId

  # Check if a certificate is present
  if ($credentials.Certificates -ne $null) {
    # Loop through each certificate
    foreach ($cert in $credentials.Certificates) {
      # Get expiry date
      $expiryDate = Get-Date $cert.EndDate
      
      # Display details
      Write-Host "Service Principal Name: {0}" -f $sp.DisplayName
      Write-Host "Certificate Thumbprint: {0}" -f $cert.Thumbprint
      Write-Host "Expiration Date: {0}" -f $expiryDate
    }
  } else {
    Write-Host "No certificate found for {0}" -f $sp.DisplayName
  }
}