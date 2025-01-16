# Retrieve the DEV_ENDPOINT
$DEV_ENDPOINT = (aws cloudformation describe-stacks --stack-name sam-app-dev | ConvertFrom-Json).Stacks.Outputs | Where-Object { $_.OutputValue -like "https://*" } | Select-Object -ExpandProperty OutputValue

# Retrieve the PROD_ENDPOINT
$PROD_ENDPOINT = (aws cloudformation describe-stacks --stack-name sam-app-prod | ConvertFrom-Json).Stacks.Outputs | Where-Object { $_.OutputValue -like "https://*" } | Select-Object -ExpandProperty OutputValue

while ($true) {
    # Change 'Uri' parameter depending on which endpoint you want to test (DEV_ENDPOINT or PROD_ENDPOINT)
    $response = Invoke-RestMethod -Uri $PROD_ENDPOINT
    $message = $response.message
    $message | Out-File -Append -FilePath .\outputs.txt
    Write-Output $message

    Start-Sleep -Seconds 0.5

    # Exit loop if "q" is pressed
    if ([console]::KeyAvailable -and [console]::ReadKey($true).Key -eq 'Q') {
        break
    }
}
