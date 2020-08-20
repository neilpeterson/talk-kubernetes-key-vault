# resource "azurerm_key_vault_secret" "sqlServerEndpoint" {
#   name         = "SQL-SERVER-NAME"
#   value        = azurerm_sql_server.sql.fully_qualified_domain_name
#   key_vault_id = azurerm_key_vault.keyvault.id
# }

# resource "azurerm_key_vault_secret" "sqlServerAdminName" {
#   name         = "SQL-USER-NAME"
#   value        = var.sqlServerAdminName
#   key_vault_id = azurerm_key_vault.keyvault.id
# }

# resource "azurerm_key_vault_secret" "sqlServerAdminPassword" {
#   name         = "SQL-PASSWORD"
#   value        = var.sqlServerAdminPassword
#   key_vault_id = azurerm_key_vault.keyvault.id
# }

# Deployment script is used to create the domaindata table in the Azure SQL DB and boot strap AKS
resource "azurerm_template_deployment" "domaindata" {
  name                = "domaindata"
  resource_group_name = azurerm_resource_group.resourceGroup.name

  template_body = <<DEPLOY
{
    "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
    "contentVersion": "1.0.0.0",
    "parameters": {
        "identity": {
           "type": "securestring"
        },
        "sqlServer": {
           "type": "string"
        },
        "sqlAdmin": {
            "type": "string"
        },
        "sqlPassword": {
            "type": "securestring"
        },
        "aksCluster": {
            "type": "string"
        },
        "aksResourceGroup": {
            "type": "string"
        },
        "aksNodeResourceGroup": {
            "type": "string"
        }
    },
    "variables": {
        "script": "https://gist.githubusercontent.com/neilpeterson/320c6356453dd913c87253ba09731151/raw/1dbc247e754316e9e1805a40da7a66d905defd07/pro-template-cis-driver.ps1"
    },
    "resources": [
        {
            "type": "Microsoft.Resources/deploymentScripts",
            "apiVersion": "2019-10-01-preview",
            "name": "runPowerShellInline",
            "location": "[resourceGroup().location]",
            "kind": "AzurePowerShell",
            "identity": {
                "type": "UserAssigned",
                "userAssignedIdentities": {"[parameters('identity')]": {}}
            },
            "properties": {
                "forceUpdateTag": "1",
                "azPowerShellVersion": "3.0",
                "arguments": "[concat('-sqlServer ', parameters('sqlServer'), ' -sqlAdmin ', parameters('sqlAdmin'), ' -sqlPassword ', parameters('sqlPassword'), ' -aksCluster ', parameters('aksCluster'), ' -aksResourceGroup ', parameters('aksResourceGroup'), ' -aksNodeResourceGroup ', parameters('aksNodeResourceGroup'))]",
                "primaryScriptUri": "[variables('script')]",
                "timeout": "PT30M",
                "cleanupPreference": "OnSuccess",
                "retentionInterval": "P1D"
            }
        }
    ]
}
DEPLOY

  parameters = {
    "identity"             = azurerm_user_assigned_identity.script-identity.id,
    "sqlServer"            = azurerm_sql_server.sql.fully_qualified_domain_name,
    "sqlAdmin"             = var.sqlServerAdminName,
    "sqlPassword"          = var.sqlServerAdminPassword,
    "aksResourceGroup"     = azurerm_resource_group.resourceGroup.name,
    "aksNodeResourceGroup" = data.azurerm_resource_group.aks-node.name
    "aksCluster"           = azurerm_kubernetes_cluster.aks.name
  }

  deployment_mode = "Incremental"
}
