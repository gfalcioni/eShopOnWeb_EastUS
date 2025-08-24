param sku string = 'S1'
param location string = resourceGroup().location
param webAppName string  // adiciona o parâmetro

var appServicePlanName = toLower('AppServicePlan-${webAppName}')

resource appServicePlan 'Microsoft.Web/serverfarms@2022-09-01' = {
  name: appServicePlanName
  location: location
  sku: {
    name: sku
    capacity: 1
  }
  properties: {
    reserved: true
  }
}

resource appService 'Microsoft.Web/sites@2022-09-01' = {
  name: webAppName
  kind: 'app,linux'
  location: location
  properties: {
    serverFarmId: appServicePlan.id
    siteConfig: {
      linuxFxVersion: 'DOTNETCORE|8.0'
      appSettings: [
        { name: 'ASPNETCORE_ENVIRONMENT', value: 'Development' }
        { name: 'UseOnlyInMemoryDatabase', value: 'true' }
      ]
    }
  }
}

output webAppName string = webAppName
