# resource "azurerm_key_vault_secret" "kvsecret" {
#   name         = "kvsecret"
#   value        = "Hello World From Key Vault"
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
        "script": "https://raw.githubusercontent.com/neilpeterson/talk-kubernetes-key-vault/master/deploy/terraform/botstrap.ps1"
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
