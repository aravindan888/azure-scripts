#!/bin/bash
# ==============================================================
# Script: 04-network-audit.sh
# Purpose: Review networking components in rg including
#          VNETs, subnets, public IPs, and NSGs.
# Usage:   ./04-network-audit.sh
# ==============================================================

RG=""

echo "VNETs in $RG:"
az network vnet list --resource-group $RG -o table

echo "Public IPs in $RG:"
az network public-ip list --resource-group $RG -o table

echo "NSGs in $RG:"
az network nsg list --resource-group $RG -o table
