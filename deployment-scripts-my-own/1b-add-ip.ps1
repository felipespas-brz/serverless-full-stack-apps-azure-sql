Connect-AzAccount -Tenant '16b3c013-d300-468d-ac64-7eda0820b6d3'

Get-AzSubscription

Set-AzContext -Subscription "2edd29f5-689f-48c5-b93e-93723216ea91"

$ipAddress = (Invoke-WebRequest -Uri "https://ipinfo.io/ip").Content

# Prompt for local ip address
# $ipAddress = Read-Host "Disconnect your VPN, open PowerShell on your machine and run '(Invoke-WebRequest -Uri "https://ipinfo.io/ip").Content'. Please enter the value (include periods) next to 'Address': "
# Write-Host "Password and IP Address stored"

$resourceGroupName = "mslearn-serverless-app"
$serverName = "bus-server350646"
$uniqueID = Get-Random -Minimum 100000 -Maximum 1000000
$firewallRuleName = "AllowedIPs$($uniqueID)"

# Create a server firewall rule that allows access from the specified IP range and all Azure services
$serverFirewallRule = New-AzSqlServerFirewallRule `
    -ResourceGroupName $resourceGroupName `
    -ServerName $serverName `
    -FirewallRuleName $firewallRuleName `
    -StartIpAddress $ipAddress -EndIpAddress $ipAddress 