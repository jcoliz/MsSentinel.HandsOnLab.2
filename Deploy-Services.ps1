param(
    [Parameter(Mandatory=$true)]
    [string]
    $ResourceGroup,
    [Parameter(Mandatory=$true)]
    [string]
    $Location,
    [string]
    $Container = "theblobz"
)

Write-Output "Creating Resource Group $ResourceGroup in $Location"
az group create --name $ResourceGroup --location $Location

Write-Output "Deploying to Resource Group $ResourceGroup"
$result = az deployment group create --name "Deploy-$(Get-Random)" --resource-group $ResourceGroup --template-file ./azuredeploy.bicep --parameter containerName=$Container | ConvertFrom-Json

Write-Output "OK"
Write-Output ""

$sentinelWorkspaceName = $result.properties.outputs.sentinelWorkspaceName.value
$storageName = $result.properties.outputs.storageName.value
$appName = $result.properties.outputs.appName.value

Write-Output "Deployed sentinel workspace $sentinelWorkspaceName"
Write-Output "Deployed storage account $storageName"
Write-Output "Deployed container application $appName"
Write-Output ""

Write-Output "When finished, run:"
Write-Output "az group delete --name $ResourceGroup"
