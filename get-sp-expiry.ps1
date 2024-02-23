# Get the service principals details and write into the file in .txt format
az ad sp list --all --output table > service-principals.txt

# Read the content of the service_principals.txt file
$servicePrincipals = Get-Content -Path "service-principals.txt"

# Iterate through each line in the output
foreach ($line in $servicePrincipals) {
    # Extract relevant information (adjust the column positions based on your output)
    $columns = $line -split '\s+' | Where-Object { $_ -ne '' }

    if ($columns.Count -ge 6) {
        $DisplayName = $columns[1]
        $AppId = $columns[3]

        # Get detailed information about the service principal
        $spDetails = az ad sp credential list --id $AppId --output table > sp-credentials.txt

        # # Iterate through the key credentials and check expiration
        # foreach ($keyCredential in $spDetails.keyCredentials) {
        #     $expirationDate = $keyCredential.endDate

        #     if ($expirationDate -ne $null) {
        #         $remainingDays = [math]::floor(($expirationDate - (Get-Date)).TotalDays)

        #         # Check if the key is expired or nearing expiration (adjust the threshold as needed)
        #         if ($remainingDays -lt 30) {
        #             Write-Host "Service Principal: $DisplayName (App ID: $AppId)"
        #             Write-Host "Key Expiration Date: $expirationDate"
        #             Write-Host "Remaining Days: $remainingDays days"
        #             Write-Host "-----------------------------"
        #         }
        #     }
        # }
    }
}