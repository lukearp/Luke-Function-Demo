var functionName = 'luketest-sqlcost-8-deploy'
module function 'function-app.bicep' = {
  name: '${functionName}-Function-Deploy'
  params: {
    functionName: functionName
    location: 'eastus'
    sqlMiPublicEndpoint: false
    stroageAccountName: 'lukesqlmicostfunction'
    subnetName: 'test'    
    vnetName: 'core-transit-eastus-vnet'
    vnetResourceGroup: 'core-transit-networking-eastus-rg'
    managedInstanceName: 'luke'
    managedInstanceResourceGroup: 'luke-rg'
    sqlPassword: 'Windows2P@ss'
    sqlUserName: 'Luke'
    azureEnvironment: 'AzureCloud'   
    sqlConnectionString: 'test'  
  }
}
