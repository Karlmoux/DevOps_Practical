param name string
param location string
param acrAdminUserEnabled bool

param adminCredentialsKeyVaultResourceId string

@secure()
param adminCredentialsKeyVaultSecretUserName string

@secure()
param adminCredentialsKeyVaultSecretUserPassword1 string

@secure()
param adminCredentialsKeyVaultSecretUserPassword2 string

resource acr 'Microsoft.ContainerRegistry/registries@2021-09-01' = {
  name: name
  location: location
  sku: {
    name: 'Basic'
  }
  properties: {
    adminUserEnabled: acrAdminUserEnabled
  }
}

resource adminCredentialsKeyVault 'Microsoft.KeyVault/vaults@2021-10-01' existing = {
  name: last(split(adminCredentialsKeyVaultResourceId, '/'))
}

resource secretUserName 'Microsoft.KeyVault/vaults/secrets@2023-02-01' = {
  name: adminCredentialsKeyVaultSecretUserName
  parent: adminCredentialsKeyVault
  properties: {
    value: acr.listCredentials().username
  }
}

resource secretUserPassword1 'Microsoft.KeyVault/vaults/secrets@2023-02-01' = {
  name: adminCredentialsKeyVaultSecretUserPassword1
  parent: adminCredentialsKeyVault
  properties: {
    value: acr.listCredentials().passwords[0].value
  }
}

resource secretUserPassword2 'Microsoft.KeyVault/vaults/secrets@2023-02-01' = {
  name: adminCredentialsKeyVaultSecretUserPassword2
  parent: adminCredentialsKeyVault
  properties: {
    value: acr.listCredentials().passwords[1].value
  }
}

output credentials object = {
  username: secretUserName.properties.value
  password1: secretUserPassword1.properties.value
  password2: secretUserPassword2.properties.value
}
