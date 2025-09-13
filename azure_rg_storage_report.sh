#!/bin/bash

# ---------------------------
# Configuration
# ---------------------------
SUBSCRIPTION_ID="<YOUR_SUBSCRIPTION_ID>"   # Replace with your Azure subscription ID

# CSV header
echo "ResourceGroup,StorageCount,StorageNames,StorageTypes"

# Loop over all Resource Groups
for rg in $(az group list --query "[].name" -o tsv); do

    # List all storage accounts in the RG
    storages=$(az storage account list --resource-group $rg --query "[].{Name:name, Type:kind}" -o tsv)

    if [ -z "$storages" ]; then
        # No storage accounts in this RG
        echo "$rg,0,N/A,N/A"
    else
        # Count storage accounts
        storage_count=$(echo "$storages" | wc -l)

        # Get names and types as comma-separated strings
        storage_names=$(echo "$storages" | awk '{print $1}' | paste -sd "," -)
        storage_types=$(echo "$storages" | awk '{print $2}' | paste -sd "," -)

        echo "$rg,$storage_count,$storage_names,$storage_types"
    fi

done
