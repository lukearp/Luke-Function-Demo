param subnetName string
param vnetName string
param vnetResourceGroup string

module subnetInfo 'subnetinfo.bicep' = {
  name: '${replace(subnetName,'-','')}-Info-Deploy'
  scope: resourceGroup(vnetResourceGroup)
  params: {
    subnetName: subnetName
    vnetName: vnetName  
  }
}

module subnetSetup 'subnetSetup.bicep' = {
  name: '${replace(subnetName,'-','')}-Deploy'
  scope: resourceGroup(vnetResourceGroup)
  params: {
    subnetId: subnetInfo.outputs.subnet.id
    properties: subnetInfo.outputs.subnet.properties
  }   
}
