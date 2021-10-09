export rg=devops-svc-rg
export sa=devopssvcacc
export container=svccontainer
export subid=<your_subscription_id>

az group create -l eastus -n ${rg}

# Take the id from the output and use it as the scopes below
az ad sp create-for-rbac -n ${rg} --role contributor --scopes ${subid}

# At this point you can create the service connection in Azure DevOps
# Project Settings -> Service Connection -> New Service Connection -> Azure Resource Manager -> Service Principle

# Take the appId from the output and use it as the assignee below
# Also take the id of the subscription your using in the subscription declaration below
az role assignment create --assignee {appId} --role Contributor --subscription ${subid}

# Create our storage account
az storage account create --resource-group ${rg} --name ${sa} --sku Standard_LRS --encryption-services blob

# Grab the storage account keys
az storage account keys list --resource-group ${rg} --account-name ${sa}

# Create storage container, use the first key from above as the below account-key

az storage container create --name ${container} --account-name ${sa} --account-key [[key]]
