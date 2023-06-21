var functionName = 'luketest-sqlcost3-deploy'
module function 'function-app.bicep' = {
  name: '${functionName}-Function-Deploy'
  params: {
    functionName: functionName
    location: 'eastus'
    sqlMiPublicEndpoint: false
    stroageAccountName: 'lukesqlmicostfunction'
    subnetIdForVNETIntegration: '/subscriptions/32eb88b4-4029-4094-85e3-ec8b7ce1fc00/resourceGroups/core-workloads-networking-eastus-rg/providers/Microsoft.Network/virtualNetworks/core-workloads-eastus-vnet/subnets/LogicApp-Subnet3'    
  }
}
