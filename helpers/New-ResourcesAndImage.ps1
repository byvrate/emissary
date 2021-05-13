

<#
    .SYNOPSIS
        A helper function to help generate an image.

    .DESCRIPTION
        Creates Azure resources and kicks off a packer image generation for the selected image type.

    .PARAMETER SubscriptionId
        The Azure subscription Id where resources will be created.

    .PARAMETER ResourceGroupName
        The Azure resource group name where the Azure resources will be created.

    .PARAMETER ImageGenerationRepositoryRoot
        The root path of the image generation repository source.

    .PARAMETER ImageType
        The type of the image being generated. Valid options are: {"Windows2016", "Windows2019", "Ubuntu1604", "Ubuntu1804"}.

    .PARAMETER AzureLocation
        The location of the resources being created in Azure. For example "East US".

    .PARAMETER Force
        Delete the resource group if it exists without user confirmation.

    .PARAMETER AzureClientId
        Client id needs to be provided for optional authentication via service principal. Example: "11111111-1111-1111-1111-111111111111"

    .PARAMETER AzureClientSecret
        Client secret needs to be provided for optional authentication via service principal. Example: "11111111-1111-1111-1111-111111111111"

    .PARAMETER AzureTenantId
        Tenant needs to be provided for optional authentication via service principal. Example: "11111111-1111-1111-1111-111111111111"

    .PARAMETER RestrictToAgentIpAddress
        If set, access to the VM used by packer to generate the image is restricted to the public IP address this script is run from. 
        This parameter cannot be used in combination with the virtual_network_name packer parameter.

    .EXAMPLE
        GenerateResourcesAndImage -SubscriptionId {YourSubscriptionId} -ResourceGroupName "shsamytest1" -ImageGenerationRepositoryRoot "C:\virtual-environments" -ImageType Ubuntu1604 -AzureLocation "East US"

    .NOTES
        This script is inspired by and based on the Azure Function
#>
param (
    [Parameter(Mandatory = $True)]
    [string] $SubscriptionId,
    [Parameter(Mandatory = $True)]
    [string] $ResourceGroupName,
    [Parameter(Mandatory = $True)]
    [string] $ImageTypeValue,
    [Parameter(Mandatory = $True)]
    [string] $AzureLocation,
    [Parameter(Mandatory = $False)]
    [string] $ImageGenerationRepositoryRoot = $pwd,
    [Parameter(Mandatory = $False)]
    [int] $SecondsToWaitForServicePrincipalSetup = 30,
    [Parameter(Mandatory = $False)]
    [string] $AzureClientId,
    [Parameter(Mandatory = $False)]
    [string] $AzureClientSecret,
    [Parameter(Mandatory = $False)]
    [string] $AzureTenantId,
    [Parameter(Mandatory = $False)]
    [Switch] $RestrictToAgentIpAddress,
    [Parameter(Mandatory = $False)]
    [Switch] $Interactive,
    [Switch] $Force
)

# This script requires importing of some modules of the virtual-environmens subtree
Import-Module (Join-Path -Path $PSScriptRoot -ChildPath  "../virtual-environments/helpers/GenerateResourcesAndImage.ps1")
[ImageType]$imageType = $ImageTypeValue
$builderScriptPath = Get-PackerTemplatePath -RepositoryRoot (Join-Path -Path $PSScriptRoot -ChildPath  "../virtual-environments") -ImageType $ImageType

if ($Interactive) {
    Connect-AzAccount -Tenent $AzureTenantId -Subscription $SubscriptionId
} else {
    $AzSecureSecret = ConvertTo-SecureString $AzureClientSecret -AsPlainText -Force
    $AzureAppCred = New-Object System.Management.Automation.PSCredential($AzureClientId, $AzSecureSecret)
    Connect-AzAccount -ServicePrincipal -Subscription $SubscriptionId -Credential $AzureAppCred -Tenant $AzureTenantId
}

Set-AzContext -Subscription $SubscriptionId -Tenant $AzureTenantId

# The resource group must already be created. 
Get-AzResourceGroup -Name $ResourceGroupName -ErrorVariable rgNotPresent -ErrorAction SilentlyContinue





