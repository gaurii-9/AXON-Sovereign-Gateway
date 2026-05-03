// AXON Sovereign Architecture - Final Hardened Build
param location string = 'centralindia'
param vaultName string = 'axon-v3-kv-${uniqueString(resourceGroup().id)}'

// 1. THE VAULT (Secure Storage)
resource keyVault 'Microsoft.KeyVault/vaults@2023-07-01' = {
  name: vaultName
  location: location
  properties: {
    sku: { family: 'A', name: 'standard' }
    tenantId: subscription().tenantId
    enableRbacAuthorization: true
  }
}

// 2. NETWORK (Clean & Standard)
resource vnet 'Microsoft.Network/virtualNetworks@2023-09-01' = {
  name: 'axon-vnet'
  location: location
  properties: {
    addressSpace: { addressPrefixes: ['10.0.0.0/16'] }
    subnets: [{
        name: 'gateway-subnet'
        properties: { addressPrefix: '10.0.1.0/24' }
    }]
  }
}

// FIXED: Public IP must be 'Standard' SKU
resource publicIP 'Microsoft.Network/publicIPAddresses@2023-09-01' = {
  name: 'axon-ip'
  location: location
  sku: { name: 'Standard' } 
  properties: { publicIPAllocationMethod: 'Static' }
}

resource nic 'Microsoft.Network/networkInterfaces@2023-09-01' = {
  name: 'axon-nic'
  location: location
  properties: {
    ipConfigurations: [{
        name: 'internal'
        properties: {
          subnet: { id: vnet.properties.subnets[0].id }
          publicIPAddress: { id: publicIP.id }
          privateIPAllocationMethod: 'Dynamic'
        }
    }]
  }
}

// 3. THE NODE (Using Standard_B2s to bypass Quota limits)
resource secureNode 'Microsoft.Compute/virtualMachines@2023-09-01' = {
  name: 'axon-secure-node'
  location: location
  properties: {
    hardwareProfile: { vmSize: 'Standard_B2s' }
    storageProfile: {
      imageReference: {
        publisher: 'Canonical', offer: '0001-com-ubuntu-server-jammy', sku: '22_04-lts-gen2', version: 'latest'
      }
      osDisk: { createOption: 'FromImage', managedDisk: { storageAccountType: 'StandardSSD_LRS' } }
    }
    osProfile: {
      computerName: 'axon-node'
      adminUsername: 'leopard_gauri'
      adminPassword: 'AxonSecurePassword123!' // Correct placement
      linuxConfiguration: {
        disablePasswordAuthentication: false 
      }
    }
    networkProfile: { networkInterfaces: [{ id: nic.id }] }
  }
}
