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
.\Deploy-Services.ps1 -ResourceGroup mssentinel-lab-2 -Location westus -Container <choose a name>
```

When this script completes, it will pass along some helpful information. Be sure to record the displayed endpoints URL.

```dotnetcli
Deployed sentinel workspace sentinel-redacted
Deployed sotrage account storage000redacted

When finished, run:
az group delete --name mssentinel-lab-1
```
