output "_1" {
  value = "az aks get-credentials --name ${azurerm_kubernetes_cluster.aks.name} --resource-group ${azurerm_resource_group.resourceGroup.name}"
}

output "_2" {
  value = "az acr login --name ${azurerm_container_registry.acr.name}"
}

output "_3" {
  value = "az acr build --registry ${azurerm_container_registry.acr.name} -f aspnet-k8s/Dockerfile --image aspnet-keyvault-demo:v1 ."
}

output "_4" {
  value = "helm install ./deploy/charts/aks-aspnet-config-provider --set SubscriptionId=${data.azurerm_client_config.current.subscription_id} --set ResourceGroupName=${azurerm_resource_group.resourceGroup.name} --set IdentityName=${azurerm_user_assigned_identity.pod-identity.name} --set IdentityClientId=${azurerm_user_assigned_identity.pod-identity.client_id} --set KeyVaultName=${azurerm_key_vault.keyvault.vault_uri} --set fqdn=${azurerm_kubernetes_cluster.aks.name}.${azurerm_resource_group.resourceGroup.location}.cloudapp.azure.com --set Image=${azurerm_container_registry.acr.login_server}/aspnet-keyvault-demo:v1 --generate-name"
}

output "_5" {
  value = "helm install ./deploy/charts/aks-csi-driver --set TenantId=${data.azurerm_client_config.current.tenant_id} --set SubscriptionId=${data.azurerm_client_config.current.subscription_id} --set ResourceGroupName=${azurerm_resource_group.resourceGroup.name} --set IdentityName=${azurerm_user_assigned_identity.pod-identity.name} --set IdentityClientId=${azurerm_user_assigned_identity.pod-identity.client_id} --set KeyVaultName=${azurerm_key_vault.keyvault.name} --set fqdn=${azurerm_kubernetes_cluster.aks.name}.${azurerm_resource_group.resourceGroup.location}.cloudapp.azure.com --set Image=${azurerm_container_registry.acr.login_server}/aspnet-keyvault-demo:v1 --generate-name"
}