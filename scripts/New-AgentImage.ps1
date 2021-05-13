# az login
# choco install packer
# Invoke-WebRequest -Uri https://aka.ms/installazurecliwindows -OutFile .\AzureCLI.msi; Start-Process msiexec.exe -Wait -ArgumentList '/I AzureCLI.msi /quiet'; rm .\AzureCLI.msi

# Reference the subtree "virtual-environments" which points to the https://github.com/actions/virtual-environments repo
$subscriptionId = "45a47ca2-196a-4d7d-a56e-cbe6b80e476d"

# Be careful, script creates a storage account based on this rg name
$resourceGroupName = "contoso-workspace-pker"
$azureClientId = "a3f57ed9-60d1-44ef-910f-512c401425e4"
$tenentId = "5e4c673c-bf0a-49b5-9d9c-0678cbe52263"

Set-Location (Join-Path $PSScriptRoot "../virtual-environments") 
Import-Module .\helpers\GenerateResourcesAndImage.ps1
GenerateResourcesAndImage `
    -SubscriptionId $subscriptionId `
    -ResourceGroupName $resourceGroupName `
    -ImageGenerationRepositoryRoot "$pwd" `
    -ImageType Ubuntu1604 `
    -AzureLocation "West US 2" `
    -AzureTenantId $tenentId `
    -RestrictToAgentIpAddress 

    