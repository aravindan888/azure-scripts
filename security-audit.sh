#!/bin/bash
# ==============================================================
# Script: 05-security-audit.sh
# Purpose: Check IAM roles and Key Vaults in rg to ensure
#          security best practices (least privilege, secrets protection).
# Usage:   ./security-audit.sh
# ==============================================================

RG="rg"

echo "Role assignments in $RG:"
az role assignment list --resource-group $RG -o table

echo "Key Vaults in $RG:"
az keyvault list --resource-group $RG -o table
