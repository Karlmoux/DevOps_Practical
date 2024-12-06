param name string
param location string
param enableVaultForDeployment bool
param roleAssignments array

resource keyVault 'Microsoft.KeyVault/vaults@2021-10-01' = {
  name: name
  location: location
  properties: {
    enabledForDeployment: enableVaultForDeployment
  }
}

resource roleAssignment 'Microsoft.Authorization/roleAssignments@2021-04-01-preview' = [for role in roleAssignments: {
  name: guid(keyVault.id, role.principalId, role.roleDefinitionIdOrName)
  properties: {
    principalId: role.principalId
    principalType: role.principalType
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', role.roleDefinitionIdOrName)
    scope: keyVault.id
  }
}]
