//
// Deploys a complete set of needed resources for the sample at:
//    https://github.com/jcoliz/MsSentinel.HandsOnLab.2
//
// Includes:
//    * Sentinel-enabled Log Analytics Workspace
//    * Azure Storage Account
//    * Blob Storage container
//    * Container app to push blobs
//

@description('Unique suffix for all resources in this deployment')
@minLength(5)
param suffix string = uniqueString(resourceGroup().id)

@description('Location for all resources.')
param location string = resourceGroup().location

@description('Name for blob storage container.')
param containerName string = 'blobz'

@description('Name for blob storage folder.')
param folderName string = 'foldr'

@description('Container image to use.')
param imageName string = 'jcoliz/mssentinel-azblob:latest'

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

// Deploy Container App Environment

module cenv './AzDeploy.Bicep/App/managedEnvironments.bicep' = {
  name: 'cenv'
  params: {
    suffix: suffix
    location: location
    logAnalyticsName: workspace.outputs.logAnalyticsName
  }
}

// Deploy container app

module capp './AzDeploy.Bicep/App/containerApp.bicep' = {
  name: 'capp'
  params: {
    suffix: suffix
    location: location
    containerAppEnvName: cenv.outputs.name
    external: false
    containers: [
      {        
        name: 'app'
        image: imageName
        resources: {
          cpu: json('0.25')
          memory: '.5Gi'
        }
        env: [
          {
            name: 'BLOBSTORAGE__CONTAINER'
            value: containerName
          }
          {
            name: 'BLOBSTORAGE__FOLDER'
            value: folderName
          }
          {
            name: 'BLOBSTORAGE__ENDPOINT'
            value: storage.outputs.storageEndpoint.blob
          }
          {
            name: 'BLOBSTORAGE__PERIOD'
            value: '00:01:00'
          }
        ]
      }
    ]
  }
}

// Assign storage contributor rights for the blob-pushing app

module role './AzDeploy.Bicep/Storage/blobdatacontribrole.bicep' = {
  params: {
    principalId: capp.outputs.principal
    containerFullName: container.outputs.name
    principalType: 'ServicePrincipal'
  }
}

output sentinelWorkspaceName string = workspace.outputs.logAnalyticsName
output storageName string = storage.outputs.storageName
output appName string = capp.outputs.name
output containerName string = containerName
output folderName string = folderName
output storageEndpoints object = storage.outputs.storageEndpoint
