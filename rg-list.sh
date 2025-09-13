#list of rgs with last modified date
#!/bin/bash

# Threshold in days to consider a Resource Group inactive
THRESHOLD=30

echo "ResourceGroup,LastModifiedResource,LastModifiedTime,DaysInactive,Status"

for rg in $(az group list --query "[].name" -o tsv); do
    # Get the most recently created/modified resource (ignoring nulls)
    latest=$(az resource list --resource-group $rg --query "sort_by([?systemData.createdAt!=null], &systemData.createdAt)[-1].{Name:name, Time:systemData.createdAt}" -o tsv)
    
    if [ -z "$latest" ]; then
        echo "$rg,N/A,N/A,N/A,Inactive"
    else
        name=$(echo $latest | awk '{print $1}')
        time=$(echo $latest | awk '{print $2}')

        # Convert to epoch seconds and calculate inactivity
        lastEpoch=$(date -d "$time" +%s)
        nowEpoch=$(date +%s)
        daysInactive=$(( (nowEpoch - lastEpoch)/86400 ))

        # Determine status
        if [ "$daysInactive" -le $THRESHOLD ]; then
            status="Active"
        else
            status="Inactive"
        fi

        echo "$rg,$name,$time,$daysInactive,$status"
    fi
done
