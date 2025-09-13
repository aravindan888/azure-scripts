#!/bin/bash
# ==============================================================
# Script: 01-resource-inventory.sh
# Purpose: Collect a full inventory of resources inside the
#          RG=" "resource group, including resource counts.
# Usage:   ./01-resource-inventory.sh
# ==============================================================

RG=""

echo "Listing all resources in $RG..."
az resource list --resource-group $RG -o table

echo "Resource counts by type..."
az resource list --resource-group $RG --query "[].type" -o tsv | sort | uniq -c
