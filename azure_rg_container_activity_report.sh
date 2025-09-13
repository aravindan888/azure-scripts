#!/bin/bash

THRESHOLD=30   # days to consider inactive

echo "ResourceGroup,LastResource,ResourceType,LastModified,DaysInactive,Status"

# Loop over all Resource Groups
for rg in $(az group list --query "[].name" -o tsv); do

    # Get the first container app in the RG
    container=$(az resource list --resource-group $rg --resource-type "Microsoft.App/containerApps" --query "[].{Name:name, Id:id}" -o tsv | head -n1)

    if [ -n "$container" ]; then
        name=$(echo $container | awk '{print $1}')
        id=$(echo $container | awk '{print $2}')

        # Get metrics for last 1 day
        cpu_values=$(az monitor metrics list --resource $id --metric "CpuPercentage" --interval 1d --query "value[].timeseries[].data[].average" -o tsv)
        mem_values=$(az monitor metrics list --resource $id --metric "MemoryPercentage" --interval 1d --query "value[].timeseries[].data[].average" -o tsv)

        # Determine status
        if [ -n "$cpu_values" ] || [ -n "$mem_values" ]; then
            status="Active"
        else
            status="Unknown"
        fi

        # Get last modified/created date
        time=$(az resource show --ids $id --query "systemData.createdAt" -o tsv)
        if [ -n "$time" ]; then
            lastEpoch=$(date -d "$time" +%s)
            nowEpoch=$(date +%s)
            daysInactive=$(( (nowEpoch - lastEpoch)/86400 ))

            if [ "$status" == "Unknown" ]; then
                if [ "$daysInactive" -le $THRESHOLD ]; then
                    status="Active"
                else
                    status="Inactive"
                fi
            fi
        else
            daysInactive="N/A"
            status="Inactive"
        fi

        echo "$rg,$name,ContainerApp,$time,$daysInactive,$status"

    else
        # No Container Apps → fallback to last modified resource in RG
        latest=$(az resource list --resource-group $rg --query "sort_by([?systemData.createdAt!=null], &systemData.createdAt)[-1].{Name:name, Time:systemData.createdAt}" -o tsv)
        if [ -z "$latest" ]; then
            echo "$rg,N/A,N/A,N/A,N/A,Inactive"
        else
            name=$(echo $latest | awk '{print $1}')
            time=$(echo $latest | awk '{print $2}')
            lastEpoch=$(date -d "$time" +%s)
            nowEpoch=$(date +%s)
            daysInactive=$(( (nowEpoch - lastEpoch)/86400 ))

            if [ "$daysInactive" -le $THRESHOLD ]; then
                status="Active"
            else
                status="Inactive"
            fi

            echo "$rg,$name,Other,$time,$daysInactive,$status"
        fi
    fi
done
