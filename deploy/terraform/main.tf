provider "azurerm" {
  version = "=2.8.0"
  features {}
}

# Resource Group
resource "azurerm_resource_group" "resourceGroup" {
  name     = "${var.resourceGroupName}-${var.identifier}"
  location = var.location
}

data "azurerm_client_config" "current" {}

data "azurerm_subscription" "current" {}