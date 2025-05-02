param(
    [Parameter(Mandatory=$true)]
    [string]
    $ResourceGroup,
    [Parameter(Mandatory=$true)]
    [string]
    $Location
)

Write-Output "Checking subscription ID"
$account = az account show | ConvertFrom-Json

$accountid = $account.id

Write-Output "OK $accountid"
Write-Output ""

Write-Output "Creating Resource Group $ResourceGroup in $Location"
az group create --name $ResourceGroup --location $Location

Write-Output "Deploying to Resource Group $ResourceGroup"
$result = az deployment group create --name "Deploy-$(Get-Random)" --resource-group $ResourceGroup --template-file ./azuredeploy.bicep | ConvertFrom-Json

Write-Output "OK"
Write-Output ""

$sentinelWorkspaceName = $result.properties.outputs.sentinelWorkspaceName.value
$storageName = $result.properties.outputs.storageName.value
$appName = $result.properties.outputs.appName.value
$containerName = $result.properties.outputs.containerName.value
$folderName = $result.properties.outputs.folderName.value
$storageEndpoints = $result.properties.outputs.storageEndpoints.value
$blobEndpoint = $storageEndpoints.blob

Write-Output "Deployed sentinel workspace $sentinelWorkspaceName"
Write-Output "Deployed storage account $storageName"
Write-Output "Deployed container application $appName"
Write-Output ""

Write-Output "Use these values for your connector:"
Write-Output "* Blob URL: $blobEndpoint$containerName"
Write-Output "* Blob folder: $folderName"
Write-Output "* Blob location: $location"
Write-Output "* Blob resource group: $ResourceGroup"
Write-Output "* Blob subscription ID: $accountid"
Write-Output "* Event grid topic: ** leave blank **"
Write-Output ""

Write-Output "When finished, run:"
Write-Output "az group delete --name $ResourceGroup"
