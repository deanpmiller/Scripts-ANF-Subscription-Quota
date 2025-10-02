
# Azure NetApp Files Quota Check Script

## 📄 Overview

This PowerShell script is designed to retrieve and display **regional capacity quotas** and **consumed quotas** for a specified Azure subscription. It is intended for use in Azure environments and requires prior authentication via Azure CLI or Azure PowerShell.

---

## ⚠️ Disclaimer

This script is provided **as-is** without any warranties or guarantees.  
It is intended for **informational and operational use** in Azure environments.

---

## 🔧 API Version

The script uses the following API version, and is set as a variable within the script:


$apiVersion = "2025-06-01"

---

## 🔐 Azure Login Requirement

You must be logged into Azure using the **Azure CLI** before running this script.

To log in and set the subscription context, use the following commands:

- `az login`
- `az account set --subscription "<your-subscription-id>"`

Alternatively, to log in via **Azure PowerShell**, use:

- `Connect-AzAccount -Subscription "<your-subscription-id>"`

You can set the subscription ID dynamically in PowerShell:

- `$SubId = (Get-AzContext).Subscription.Id`

Or hard-code it directly—both options are included in the script.

---
 ## 🔧 Example- Sorts based on regional quota
 
<img width="2582" height="819" alt="image" src="https://github.com/user-attachments/assets/7cfe080f-896a-4f94-a554-0a3e495c251a" />


