@description('The location for the resources')
param location string = resourceGroup().location

module acr './modules/acr.bicep' = {
  name: 'acrModule'
  params: {
    name: 'KarlExerciseACR'
    location: location
    acrAdminUserEnabled: true
  }
}


module appServicePlan './modules/asp.bicep' = {
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

module webApp './modules/awa.bicep' = {
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
