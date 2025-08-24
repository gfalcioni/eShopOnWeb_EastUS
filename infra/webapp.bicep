param sku string = 'S1'
param location string = resourceGroup().location

// Gera um nome único para o WebApp baseado no resourceGroup
var webAppName = 'eshop-${uniqueString(resourceGroup().id)}'
var appServicePlanName = toLower('AppServicePlan-${webAppName}')

resource appServicePlan 'Microsoft.Web/serverfarms@2022-09-01' = {
  name: appServicePlanName
  location: location
  sku: {
    name: sku
    capacity: 1
  }
  properties: {
    reserved: true // Linux App Service
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
        {
          name: 'ASPNETCORE_ENVIRONMENT'
          value: 'Development'
        }
        {
          name: 'UseOnlyInMemoryDatabase'
          value: 'true'
        }
      ]
    }
  }
}

// 🔹 Output para capturar o nome do WebApp dinamicamente no pipeline
output webAppName string = webAppName
