var functionName = 'luketest-sqlcost-7-deploy'
module function 'function-app.bicep' = {
  name: '${functionName}-Function-Deploy'
  params: {
    functionName: functionName
    location: 'eastus'
    sqlMiPublicEndpoint: true
    stroageAccountName: 'lukesqlmicostfunction'
    //subnetIdForVNETIntegration: '/subscriptions/32eb88b4-4029-4094-85e3-ec8b7ce1fc00/resourceGroups/vwan/providers/Microsoft.Network/virtualNetworks/route-vnet/subnets/default'    
    managedInstanceName: 'luke'
    managedInstanceResourceGroup: 'luke-rg'
    sqlPassword: 'Windows2P@ss'
    sqlUserName: 'Luke'
    azureEnvironment: 'AzureCloud'   
    sqlConnectionString: 'test'  
  }
}
