#!/bin/bash
# ==============================================================
# Script: 03-storage-audit.sh
# Purpose: Audit storage accounts in rg, including type,
#          SKU, and whether secure transfer (HTTPS only) is enabled.
# Usage:   ./-storage-audit.sh
# ==============================================================

RG=""

echo "Storage accounts in $RG:"
az storage account list --resource-group $RG -o table

for sa in $(az storage account list --resource-group $RG --query "[].name" -o tsv); do
  echo "Checking security settings for $sa..."
  az storage account show --name $sa --resource-group $RG \
    --query "{Name:name,Kind:kind,Sku:sku.name,HTTPSOnly:enableHttpsTrafficOnly}" -o json
done
