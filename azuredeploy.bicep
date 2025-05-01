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

// Deploy container app

// This is a placeholder, until we have the actual blob creation
// container image pushed
module blobApp 'AzDeploy.Bicep/App/containerAppCompleteWeb.bicep' = {
  name: 'blobApp'
  params: {
    suffix: suffix
    location: location
    webImageName: 'jcoliz/mssentinel-synthetic:latest'
    ingressPort: 8080
  }
}

// Assign storage contributor rights for the blob-pushing app

module role './AzDeploy.Bicep/Storage/blobdatacontribrole.bicep' = {
  params: {
    principalId: blobApp.outputs.principal
    containerFullName: container.outputs.name
    principalType: 'ServicePrincipal'
  }
}

// TODO: Deploy app configuration store
// https://learn.microsoft.com/en-us/azure/azure-app-configuration/quickstart-container-apps?tabs=azure-portal

module config './AzDeploy.Bicep/App/appConfiguration.bicep' = {
  name: 'config'
  params: {
    suffix: suffix
    location: location
  }
}

// TODO: Assign "App Configuration Data Reader" to the app

// TODO: Enter config properties for: Container, Folder, Blob Endpoint

output sentinelWorkspaceName string = workspace.outputs.logAnalyticsName
output storageName string = storage.outputs.storageName
