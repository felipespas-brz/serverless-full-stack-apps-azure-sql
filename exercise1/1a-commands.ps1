Install-Module -Name Az -Repository PSGallery -Force -Scope AllUsers

Connect-AzAccount -Tenant '16b3c013-d300-468d-ac64-7eda0820b6d3'

Get-AzSubscription

Set-AzContext -Subscription "2edd29f5-689f-48c5-b93e-93723216ea91"

(Invoke-WebRequest -Uri "https://ipinfo.io/ip").Content

# 177.8.126.179

# Collect password 
$adminSqlLogin = "cloudadmin"
$password = Read-Host "Your username is 'cloudadmin'. Please enter a password for your Azure SQL Database server that meets the password requirements"

# Enterprise001!

# Prompt for local ip address
$ipAddress = Read-Host "Disconnect your VPN, open PowerShell on your machine and run '(Invoke-WebRequest -Uri "https://ipinfo.io/ip").Content'. Please enter the value (include periods) next to 'Address': "
Write-Host "Password and IP Address stored"

# 177.8.126.179

# Power shell to create a resource group
$resourceGroupName = "mslearn-serverless-app"
$location = "eastus2"
New-AzResourceGroup -Name $resourceGroupName -Location $location

# Get resource group and location and random string
$resourceGroupName = "mslearn-serverless-app"
$resourceGroup = Get-AzResourceGroup | Where ResourceGroupName -like $resourceGroupName
$uniqueID = Get-Random -Minimum 100000 -Maximum 1000000
$location = $resourceGroup.Location
# The logical server name has to be unique in the system
$serverName = "bus-server$($uniqueID)"
# The sample database name
$databaseName = "bus-db"    
Write-Host "Please note your unique ID for future exercises in this module:"  
Write-Host $uniqueID
Write-Host "Your resource group name is:"
Write-Host $resourceGroupName
Write-Host "Your resources were deployed in the following region:"
Write-Host $location
Write-Host "Your server name is:"
Write-Host $serverName

# PS C:\_Github\serverless-full-stack-apps-azure-sql> Write-Host $uniqueID
# 761241
# PS C:\_Github\serverless-full-stack-apps-azure-sql> Write-Host "Your resource group name is:"
# Your resource group name is:
# PS C:\_Github\serverless-full-stack-apps-azure-sql> Write-Host $resourceGroupName
# mslearn-serverless-app
# PS C:\_Github\serverless-full-stack-apps-azure-sql> Write-Host "Your resources were deployed in the following region:"
# Your resources were deployed in the following region:
# PS C:\_Github\serverless-full-stack-apps-azure-sql> Write-Host $location
# eastus2
# PS C:\_Github\serverless-full-stack-apps-azure-sql> Write-Host "Your server name is:"
# Your server name is:
# PS C:\_Github\serverless-full-stack-apps-azure-sql> Write-Host $serverName
# bus-server761241

# Create a new server with a system wide unique server name
$server = New-AzSqlServer -ResourceGroupName $resourceGroupName `
    -ServerName $serverName `
    -Location $location `
    -SqlAdministratorCredentials $(New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $adminSqlLogin, $(ConvertTo-SecureString -String $password -AsPlainText -Force))

# Create a server firewall rule that allows access from the specified IP range and all Azure services
$serverFirewallRule = New-AzSqlServerFirewallRule `
    -ResourceGroupName $resourceGroupName `
    -ServerName $serverName `
    -FirewallRuleName "AllowedIPs" `
    -StartIpAddress $ipAddress -EndIpAddress $ipAddress 

$allowAzureIpsRule = New-AzSqlServerFirewallRule `
    -ResourceGroupName $resourceGroupName `
    -ServerName $serverName `
    -AllowAllAzureIPs

# Create a database
$database = New-AzSqlDatabase  -ResourceGroupName $resourceGroupName `
    -ServerName $serverName `
    -DatabaseName $databaseName `
    -Edition "GeneralPurpose" -Vcore 4 -ComputeGeneration "Gen5" `
    -ComputeModel Serverless -MinimumCapacity 0.5

Write-Host "Database deployed."

# bus-server761241.database.windows.net

# Server=tcp:bus-server761241.database.windows.net,1433;Initial Catalog=bus-db;User ID=cloudadmin;Password=Enterprise001!;Connection Timeout=30;

# Server=bus-server761241.database.windows.net,1433;Initial Catalog=bus-db;User ID=cloudadmin;Password=Enterprise001!;Connection Timeout=30;
