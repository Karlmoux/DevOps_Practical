@description('The location for the resources')
param location string = resourceGroup().location

module acr './modules/azureContainerRegistry.bicep' = {
  name: 'acrModule'
  params: {
    name: 'KarlExerciseACR'
    location: location
    acrAdminUserEnabled: true
  }
}


module appServicePlan './modules/appServicePlan.bicep' = {
  name: 'appServicePlanModule'
  params: {
    name: 'KarlExerciseAppServicePlan'
    location: location
    sku: {
      capacity: 1
      family: 'B'
      name: 'B1'
      size: 'B1'
      tier: 'Basic'
    }
    kind: 'Linux'
    reserved: true
  }
}

module webApp './modules/webApp.bicep' = {
  name: 'webAppModule'
  params: {
    name: 'KarlExerciseWebApp'
    location: location
    kind: 'app'
    serverFarmResourceId: appServicePlan.outputs.resourceId
    siteConfig: {
      linuxFxVersion: 'DOCKER|KarlExerciseACR.azurecr.io/myImage:latest'
      appCommandLine: ''
    }
  }
}
