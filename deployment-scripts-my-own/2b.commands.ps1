az login

# set the right subscription
az account set --subscription "2edd29f5-689f-48c5-b93e-93723216ea91"

# Resource group name and resource group
$resourceGroupName = "mslearn-serverless-app"
$resourceGroup = Get-AzResourceGroup | Where ResourceGroupName -like $resourceGroupName
$location = $resourceGroup.Location

# # Get the repository name
# $appRepository = Read-Host "Enter your GitHub repository URL (e.g. https://github.com/[username]/serverless-full-stack-apps-azure-sql):"

# # Clone the repo - note this asks for the token
# $cloneRepository = git clone $appRepository

Set-Location "C:\_Github\serverless-full-stack-apps-azure-sql\"

# Get subscription ID 
$subId = [Regex]::Matches($resourceGroup.ResourceId, "(\/subscriptions\/)+(.*\/)+(.*\/)").Groups[2].Value
$subId = $subId.Substring(0,$subId.Length-1)

# Deploy logic app
az deployment group create --name DeployResources --resource-group $resourceGroupName `
    --template-file deployment-scripts-my-own\template.json `
    --parameters subscription_id=$subId location=$location


# post url
https://prod-01.eastus.logic.azure.com:443/workflows/36247fbdbde94f3a90ab2853b96f9417/triggers/manual/paths/invoke?api-version=2016-10-01&sp=%2Ftriggers%2Fmanual%2Frun&sv=1.0&sig=5k6J92x7k_tSWCbHMcpHAMsdTd_KPFlnAC-CAeWEf5Y