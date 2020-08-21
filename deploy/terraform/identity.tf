# Managed Identity (Deployment Script)
resource "azurerm_user_assigned_identity" "script-identity" {
  resource_group_name = azurerm_resource_group.resourceGroup.name
  location            = azurerm_resource_group.resourceGroup.location
  name                = "deployment-script-identity"
}

# Managed Identity (Pod Identity)
resource "azurerm_user_assigned_identity" "pod-identity" {
  resource_group_name = azurerm_resource_group.resourceGroup.name
  location            = azurerm_resource_group.resourceGroup.location
  name                = "aks-pod-identity"
}

# Pod Identity > Key Vault
resource "azurerm_key_vault_access_policy" "aks_pod_identity" {
  key_vault_id = azurerm_key_vault.keyvault.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = azurerm_user_assigned_identity.pod-identity.principal_id

  secret_permissions = [
    "get", "list"
  ]
}

# Pod Identity reader access to the resource group
resource "azurerm_role_assignment" "pod-identity-assignment" {
  scope                = azurerm_resource_group.resourceGroup.id
  role_definition_name = "Reader"
  principal_id         = azurerm_user_assigned_identity.pod-identity.principal_id
}

# Managed Identity Access (Resource Group for Deployment Script)
# Check / Modify Access for this one
resource "azurerm_role_assignment" "script-identity-assignment" {
  scope                = data.azurerm_subscription.current.id
  role_definition_name = "Contributor"
  principal_id         = azurerm_user_assigned_identity.script-identity.principal_id
}

# AKS (SystemAssigned Identity) > ACR Pull Access
resource "azurerm_role_assignment" "aks-acr-access" {
  scope                            = azurerm_container_registry.acr.id
  role_definition_name             = "AcrPull"
  principal_id                     = azurerm_kubernetes_cluster.aks.kubelet_identity[0].object_id
  skip_service_principal_aad_check = true
}

# Get AKS node resource group id
data "azurerm_resource_group" "aks-node" {
  name = azurerm_kubernetes_cluster.aks.node_resource_group
}

# AKS (SystemAssigned Identity) Pod Identity
resource "azurerm_role_assignment" "aks-pod-identity-mio-access" {
  scope                            = data.azurerm_resource_group.aks-node.id
  role_definition_name             = "Managed Identity Operator"
  principal_id                     = azurerm_kubernetes_cluster.aks.kubelet_identity[0].object_id
  skip_service_principal_aad_check = true
}

# AKS (SystemAssigned Identity) Pod Identity
resource "azurerm_role_assignment" "aks-pod-identity-mio-access-main-rg" {
  scope                            = azurerm_resource_group.resourceGroup.id
  role_definition_name             = "Managed Identity Operator"
  principal_id                     = azurerm_kubernetes_cluster.aks.kubelet_identity[0].object_id
  skip_service_principal_aad_check = true
}

# AKS (SystemAssigned Identity) Pod Identity
resource "azurerm_role_assignment" "aks-pod-identity-vm-access" {
  scope                            = data.azurerm_resource_group.aks-node.id
  role_definition_name             = "Virtual Machine Contributor"
  principal_id                     = azurerm_kubernetes_cluster.aks.kubelet_identity[0].object_id
  skip_service_principal_aad_check = true
}
