# Azure Kubernetes Service
resource "azurerm_kubernetes_cluster" "aks" {
  name                = "${var.aksName}-${var.identifier}"
  location            = azurerm_resource_group.resourceGroup.location
  resource_group_name = azurerm_resource_group.resourceGroup.name
  dns_prefix          = "exampleaks1"
  kubernetes_version  = "1.17.9"

  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_D2_v2"
  }

  role_based_access_control {
    enabled = true
  }

  identity {
    type = "SystemAssigned"
  }
}

# Azure Container Registry
resource "azurerm_container_registry" "acr" {
  name                = "${var.continerRegistryName}${var.identifier}"
  resource_group_name = azurerm_resource_group.resourceGroup.name
  location            = azurerm_resource_group.resourceGroup.location
  sku                 = "Premium"
  admin_enabled       = false
}

# Key Vault
resource "azurerm_key_vault" "keyvault" {
  name                = "${var.keyvaultName}${var.identifier}"
  location            = azurerm_resource_group.resourceGroup.location
  resource_group_name = azurerm_resource_group.resourceGroup.name
  tenant_id           = data.azurerm_client_config.current.tenant_id
  sku_name            = "standard"

  # Provide current context acces to create secrets
  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    secret_permissions = [
      "set",
      "get",
      "delete"
    ]
  }
}

# SQL Server
resource "azurerm_sql_server" "sql" {
  name                         = "${var.sqlServerName}${var.identifier}"
  resource_group_name          = azurerm_resource_group.resourceGroup.name
  location                     = azurerm_resource_group.resourceGroup.location
  version                      = "12.0"
  administrator_login          = var.sqlServerAdminName
  administrator_login_password = var.sqlServerAdminPassword
}

# SQL Database
resource "azurerm_sql_database" "database" {
  name                = "domaindb"
  resource_group_name = azurerm_resource_group.resourceGroup.name
  location            = azurerm_resource_group.resourceGroup.location
  server_name         = azurerm_sql_server.sql.name
}

# SQL Firewall
resource "azurerm_sql_firewall_rule" "azure" {
  name                = "azure"
  resource_group_name = azurerm_resource_group.resourceGroup.name
  server_name         = azurerm_sql_server.sql.name
  start_ip_address    = "0.0.0.0"
  end_ip_address      = "0.0.0.0"
}
