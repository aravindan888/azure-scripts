#!/bin/bash
# ==============================================================
# Script: 02-vm-audit.sh
# Purpose: Check all virtual machines in RG="", including
#          their power state, size, OS type, and patch status.
# Usage:   ./02-vm-audit.sh
# ==============================================================

RG=""

echo "VMs in $RG:"
az vm list --resource-group $RG --show-details -o table

echo "Checking OS + Patch State..."
for vm in $(az vm list --resource-group $RG --query "[].name" -o tsv); do
  echo "VM: $vm"
  az vm get-instance-view --name $vm --resource-group $RG \
    --query "{Name:name,OS:storageProfile.osDisk.osType,Updates:instanceView.patchStatus}" -o json
done
