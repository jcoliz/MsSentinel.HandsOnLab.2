//
// Deploys a complete set of needed resources for the sample at:
//    https://github.com/jcoliz/MsSentinel.HandsOnLab.2
//
// Includes:
//    * Sentinel-enabled Log Analytics Workspace
//    * Azure Storage Account
//    * Blob Storage container
//

@description('Unique suffix for all resources in this deployment')
@minLength(5)
param suffix string = uniqueString(resourceGroup().id)

@description('Location for all resources.')
param location string = resourceGroup().location

@description('Name for blob storage container.')
param containerName string = 'blobz'

// Deploy Microsoft Sentinel Workspace

module workspace './AzDeploy.Bicep/SecurityInsights/sentinel-complete.bicep' = {
  name: 'workspace'
  params: {
    suffix: suffix
    location: location
  }
}

// Deploy Storage account

module storage './AzDeploy.Bicep/Storage/storage.bicep' = {
  name: 'storage'
  params: {
    suffix: suffix
    location: location
  }
}

// Deploy Blob Container

module container './AzDeploy.Bicep/Storage/storcontainer.bicep' = {
  name: 'container'
  params: {
    account: storage.outputs.storageName
    name: containerName
  }
}

// TODO: Deploy blob creation app
// This will be added once the blob creation app is implemented!
// For now, generate blobs manually

output sentinelWorkspaceName string = workspace.outputs.logAnalyticsName
output storageName string = storage.outputs.storageName
output blobEndpoint string = storage.outputs.storageEndpoint.blob
