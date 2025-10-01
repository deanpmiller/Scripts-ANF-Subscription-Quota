# ------------------------------------------------------------------------------------
# DISCLAIMER:
# This script is provided as-is without any warranties or guarantees.
# It is intended for informational and operational use in Azure environments.
#
# You must be logged into Azure using the Azure CLI before running this script.
# To log in and set the subscription context, use the following commands:
#   az login
#   az account set --subscription "<your-subscription-id>"
# 
# To logon via Azure Powershell 
#  Connect-AzAccount -Subscription "<your-subscription-id>"
# Alternatively, you can set the subscription ID dynamically in PowerShell:
#   $SubId = (Get-AzContext).Subscription.Id
# ------------------------------------------------------------------------------------

# Define the API version for Azure NetApp Files
$apiVersion = "2025-06-01"

# Set the subscription ID (can be dynamically set using Get-AzContext)
#   $SubId = (Get-AzContext).Subscription.Id
    $SubId = "Insert your subscription ID"

# Construct the URI to get all NetApp accounts in the subscription
$anf_accounts = "https://management.azure.com/subscriptions/$SubId/providers/Microsoft.NetApp/netAppAccounts?api-version=$apiVersion"

# Send a REST API request to retrieve NetApp account data
$response = Invoke-AzRestMethod -Method GET -Uri $anf_accounts
$data = $response.Content | ConvertFrom-Json

# Extract and sort unique regions from the NetApp accounts
$regions = $data.value.location | Sort-Object -Unique

# Initialise an array to store usage data
$usageData = @()

# Loop through each region to collect usage metrics
foreach ($region in $regions) {
    # Construct the URI to get usage data for the region
    $uri = "https://management.azure.com/subscriptions/$SubId/providers/Microsoft.NetApp/locations/$region/usages?api-version=$apiVersion"
    
    # Send a REST API request to retrieve usage data
    $response = Invoke-AzRestMethod -Method GET -Uri $uri
    $data = $response.Content | ConvertFrom-Json

    # Loop through each usage item and calculate percentage consumed
    foreach ($item in $data.value) {
        $percentage = ($item.currentValue / $item.limit) * 100
        $usageData += [PSCustomObject]@{
            Region = $region
            "Consumed Regional capacity quota per subscription" = "$($item.currentValue) TB"
            "Allocated Regional Quota per subscription" = "$($item.limit) TB"
            "Percentage Consumed" = "{0:N2}%" -f $percentage
            _SortKey = $percentage  # hidden field for sorting
        }
    }
}

# Sort the usage data by percentage consumed in descending order
$usageDataSorted = $usageData | Sort-Object -Property _SortKey -Descending

# Display the sorted usage data in a formatted table
$usageDataSorted | Select-Object `
    @{Name="Region";Expression={$_.Region}}, `
    @{Name="Consumed Regional Capacity quota`nper subscription";Expression={$_.'Consumed Regional capacity quota per subscription'}}, `
    @{Name="Allocated Regional Quota`nper subscription";Expression={$_.'Allocated Regional Quota per subscription'}}, `
    @{Name="Percentage Consumed";Expression={$_.'Percentage Consumed'}} |

    Format-Table -AutoSize
