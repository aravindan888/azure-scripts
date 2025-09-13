#!/bin/bash
# ==============================================================
# Script: 08-cost-report.sh
# Purpose: Generate estimated cost for  RG over the
#          last 30 days using Azure consumption API.
# Usage:   ./08-cost-report.sh
# ==============================================================

RG="rg"
END_DATE=$(date +%Y-%m-%d)
START_DATE=$(date -d "-30 days" +%Y-%m-%d)

echo "Cost for $RG from $START_DATE to $END_DATE"
az consumption usage list --start-date $START_DATE --end-date $END_DATE -o json \
  | jq -r --arg rg "$RG" '.[] | select(.resourceGroup==$rg) | .pretaxCost' \
  | awk -v rg=$RG '{sum+=$1} END {print rg","sum}'
