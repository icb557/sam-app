# Retrieve the DEV_ENDPOINT
$DEV_ENDPOINT = (aws cloudformation describe-stacks --stack-name sam-app-dev | ConvertFrom-Json).Stacks.Outputs | Where-Object { $_.OutputValue -like "https://*" } | Select-Object -ExpandProperty OutputValue

# Retrieve the PROD_ENDPOINT
$PROD_ENDPOINT = (aws cloudformation describe-stacks --stack-name sam-app-prod | ConvertFrom-Json).Stacks.Outputs | Where-Object { $_.OutputValue -like "https://*" } | Select-Object -ExpandProperty OutputValue

while ($true) {
    $response = curl -s $DEV_ENDPOINT | ConvertFrom-Json
    $message = $response.message
    $message | Out-File -Append -FilePath outputs.txt
    Write-Output $message

    Start-Sleep -Seconds 1

    # Exit loop if "q" is pressed
    if ([console]::KeyAvailable -and [console]::ReadKey($true).Key -eq 'Q') {
        break
    }
}
