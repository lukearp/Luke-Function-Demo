param subnetName string
param vnetName string

resource vnet 'Microsoft.Network/virtualNetworks@2022-07-01' existing = {
  name: vnetName
}

resource subnet 'Microsoft.Network/virtualNetworks/subnets@2022-07-01' existing = {
  name: subnetName
  parent: vnet  
}

module subnetSetup 'subnetSetup.bicep' = {
  name: '${replace(subnet.name,'-','')}-Deploy'
  params: {
    subnetId: subnet.id
    properties: subnet.properties
  }   
}

output properties object = subnet.properties
