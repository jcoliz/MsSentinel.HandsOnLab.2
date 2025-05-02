# Microsoft Sentinel Hands On Lab #2

When this lab is complete, participants will set up a Microsoft Sentinel workspace, and connect a Blob-storage-based Codeless Connector Platform connector to a blob storage container.

## Prerequisites

To participate in this lab, you will first need:

* An Azure Account. Set up a [Free Azure Account](https://azure.microsoft.com/en-us/pricing/purchase-options/azure-account) to get started.
* [Azure CLI tool with Bicep](https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/install#azure-cli)
* A git client, e.g. [Git for Windows](https://gitforwindows.org/)
* Execution policy configured to run PowerShell scripts, see [About Execution Policies](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_execution_policies)
* A code editor, e.g. [Visual Studio Code](https://code.visualstudio.com/)

## Setup

Please complete these steps before beginning the lab.

### 1. Clone this repo

Clone this repo with submodules so you have the [AzDeploy.Bicep](https://github.com/jcoliz/AzDeploy.Bicep) project handy with the necessary module templates.

```powershell
git clone --recurse-submodules https://github.com/jcoliz/MsSentinel.HandsOnLab.2.git
```

### 2. Log into Azure

In a terminal window, ensure you are logged into Azure

```dotnetcli
az login
```

Then verify that the subscription you're logged into is where you want to deploy. Make adjustments as needed.

```dotnetcli
az account show
```

## Deploy resources

In this lab, you will create a resource group and deploy the following resources to your Azure subscription:

* Sentinel-enabled Log Analytics Workspace
* Azure Container App running a synthetic API endpoint

To deploy these, run the [Deploy-Services.ps1](./Deploy-Services.ps1) script. Supply a resource group name and
Azure datacenter location according to your preference.

```dotnetcli
.\Deploy-Services.ps1 -ResourceGroup mssentinel-lab-2 -Location westus
```

When this script completes, it will pass along some helpful information. Be sure to record the displayed endpoints URL.

```dotnetcli
Deployed sentinel workspace sentinel-redacted
Deployed storage account storage000redacted
Deployed container application capp-redacted

Use these values for your connector:
* Blob URL: https://storage000redacted.blob.core.windows.net/blobz
* Blob folder: foldr
* Blob location: westus
* Blob resource group: mssentinel-lab-2
* Blob subscription ID: redacted
* Event grid topic: ** leave blank **

When finished, run:
az group delete --name mssentinel-lab-2
```

## Validate Resources

TODO: Steps to take to ensure that deployment produced expected results

1. Check deployment logs
1. Check resource group
1. Check app logs
1. Check storage container

## Deploy solution &amp; connector

TODO: Steps to deploy solution and connector

1. Enable Sentinel health monitoring
1. Deploy solution
1. Check deployment logs
1. Deploy connector
1. Check deployment logs

## Validate data flow

TODO: Steps to troubleshoot data flow

1. Check that the storage account has an "Microsoft.Storage.BlobCreated" Event Subscription, with expected prefix folder.
1. Click into the Event Subscription details. Ensure the "Endpoint" is {name}-notification
1. Check that the Storage account has two queues, {name}-dlq and {name}-notification.
1. Check the role assignments on each queue. Ensure expected App Registration (e.g. "ScubaSentinelToStorageProd") has Storage Queue Data Contributor role. You can verify it's the correct app by clicking on its name, and comparing Object ID on the "Enterprise Application Overview" page with the Service Principal ID in the connector deployment page.
1. Check the metrics on Events page for Storage Account. Look for Published Events and Delivered Events to jump up to 1. Refresh as needed.
1. Check the {name}-notification queue quickly. Look for a message to arrive in that queue with folder and file name matching the file you just added. 
1. Now we wait! Could be up to 40 minutes. 10 is more common.
1. Refresh regularly for a few minutes, could be up to 10. The event should disappear from the queue because it has been picked up by the connector.
1. Check the metrics for the DCR. Look for "Log Ingestion Requests per minute" to come up.
1. Check the Sentinel Logs, run a simple KQL query for just the table name. Look for matching data to come up.
1. Visit the connector page. Look for green status, and indication that "last log received" was recently.
1. Problems? Check Sentinel Health table
