#!/bin/bash
# ==============================================================
# Script: 07-tags-audit.sh
# Purpose: Check if resources in rg are properly tagged
#          (env, owner, costCenter) for governance & cost tracking.
# Usage:   ./07-tags-audit.sh
# ==============================================================

RG="rg"

echo "Resources and tags in $RG:"
az resource list --resource-group $RG --query "[].{Name:name,Tags:tags}" -o table
