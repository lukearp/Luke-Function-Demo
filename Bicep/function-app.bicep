param functionName string
param location string
param sqlMiPublicEndpoint bool = true
param subnetName string = ''
param vnetName string = ''
param vnetResourceGroup string = ''
param vnetRouteAll bool = false
param stroageAccountName string
param managedInstanceName string
param managedInstanceResourceGroup string
param sqlUserName string
@secure()
param sqlPassword string
@secure()
param sqlConnectionString string
@allowed([
  'AzureCloud'
  'AzureUSGovernment'
])
param azureEnvironment string = 'AzureCloud'
param tags object = {}
param gitRepoUrl string = 'https://github.com/lukearp/Luke-Function-Demo.git'
param gitBranch string = 'deploy'
//param zipUrl string = 'https://github.com/lukearp/Luke-Function-Demo/releases/download/Current/Release-6.22.2023.zip'

var appSettings = [
  {
    name: 'FUNCTIONS_EXTENSION_VERSION'
    value: '~4'
  }
  {
    name: 'FUNCTIONS_WORKER_RUNTIME'
    value: 'powershell'
  }
  {
    name: 'AzureWebJobsStorage'
    value: 'DefaultEndpointsProtocol=https;AccountName=${storageAccount.name};AccountKey=${storageAccount.listKeys().keys[0].value};EndpointSuffix=${suffix}'
  }
  {
    name: 'RESOURCE_GROUP'
    value: managedInstanceResourceGroup
  }
  {
    name: 'MANAGED_INSTANCE_NAME'
    value: managedInstanceName
  }
  {
    name: 'SQL_USER_NAME'
    value: sqlUserName
  }
  {
    name: 'SQL_USER_PASSWORD'
    value: sqlPassword
  }
  {
    name: 'SQL_CONNECTION_STRING'
    value: sqlConnectionString
  }
]
var suffix = azureEnvironment == 'AzureCloud' ? 'core.windows.net' : 'core.usgovcloudapi.net'
var properties = sqlMiPublicEndpoint == true ? {
  enabled: true
  serverFarmId: appPlan.id
  siteConfig: {
    appSettings: appSettings
    netFrameworkVersion: 'v6.0'
    powerShellVersion: '7.2'
    alwaysOn: true
    cors: {
      allowedOrigins: [
        'https://portal.azure.com'
      ] 
    }
  }
} : {
  enabled: true
  serverFarmId: appPlan.id
  siteConfig: {
    appSettings: appSettings
    netFrameworkVersion: 'v6.0'
    powerShellVersion: '7.2'
    alwaysOn: true
    cors: {
      allowedOrigins: [
        'https://portal.azure.com'
      ] 
    }
  }
  virtualNetworkSubnetId: '${subscription().id}/resourceGroups/${vnetResourceGroup}/providers/Microsoft.Network/virtualNetworks/${vnetName}/subnets/${subnetName}'
  vnetRouteAllEnabled: vnetRouteAll
}

module subnetSetup 'subnetProperties.bicep' = if(sqlMiPublicEndpoint == false) {
  name: '${functionName}-Subnet-Delegation'
  params: {
    subnetName: subnetName
    vnetName: vnetName 
    vnetResourceGroup: vnetResourceGroup
  }
}

var sku = {
  name: 'B1'
  tier: 'Basic'
}

resource appPlan 'Microsoft.Web/serverfarms@2022-09-01' = {
  location: location
  name: '${functionName}-Plan'
  kind: 'app'
  sku: sku
  tags: tags
  properties: {
    perSiteScaling: false
    elasticScaleEnabled: false
    maximumElasticWorkerCount: 1
    isSpot: false
    reserved: false
    isXenon: false
    hyperV: false
    targetWorkerCount: 0
    targetWorkerSizeId: 0
    zoneRedundant: false
  }
}

resource storageAccount 'Microsoft.Storage/storageAccounts@2022-09-01' = {
  kind: 'StorageV2'
  location: location
  name: stroageAccountName
  sku: {
    name: 'Standard_LRS'
  }
  tags: tags
  properties: {}
}

resource function 'Microsoft.Web/sites@2022-09-01' = {
  location: location
  name: functionName
  dependsOn: [
    subnetSetup
  ]
  kind: 'functionapp'
  identity: {
    type: 'SystemAssigned'
  }
  tags: tags
  properties: properties
}

resource sourceControl 'Microsoft.Web/sites/sourcecontrols@2022-09-01' = {
  name: 'web'
  parent: function
  properties: {
    branch: gitBranch
    repoUrl: gitRepoUrl
    isGitHubAction: false
    isManualIntegration: true
  }
}
