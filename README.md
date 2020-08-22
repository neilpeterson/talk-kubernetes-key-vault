# AKS > Key Vault Demos

TODO

- Remove Ingress Controller, perhaps use nodeport service type and port-forward for all demos (speed)
- Talking point on .net configuration providers, precidence

## Quickstart

Ensure both the Azure CLI, Terraform, and Docker are installed on your development system and that the Azure CLI is authenticated with Azure.

Run these commands to deploy / configure the infrastructure. When prompted, type 'yes' and hit enter.

```
terraform init deploy/terraform/
terraform apply deploy/terraform/
```

## AAD Pod Identity

Enables Kubernetes applications to access cloud resources using AAD identities.

https://github.com/Azure/aad-pod-identity

**Components**

- Managed Identity Controller (MIC) - Kubernetres custom resource that watches for changes to pods, AzureIdentoty, and AzureIdentityBindings.

**Commands**

```
kubectl get azureidentity
kubectl get azureidentitybinding
```

## CSI Solution

## Azure Key Vault Configuration Provider in ASP.NET Core

Loads app configuration values from Azure Key Vault secrets.

- Controll access to sensitive configuration data
- Meets FIPS 140-2 Level 2 validated Hardware Security Module
- Using [Azure Active Directory Pod Identity](https://github.com/Azure/aad-pod-identity) for Key Vault access


Configuration manager precedence

- JSON, XL, INI
- Command-line arguments
- Environment variables
- In memory .NET objects
- Secret Manager storage
- Encrypted in Azure Key Vault

nuget package - https://www.nuget.org/packages/Microsoft.Extensions.Configuration.AzureKeyVault/
Documentation - https://docs.microsoft.com/en-us/aspnet/core/security/key-vault-configuration?view=aspnetcore-3.1

*Demo Steps*

- Show app and Key Vault configuration provider code
- Run app locally
- Show appsettings.ini
- Run Helm chart
- App should use the value from appsettings.json
- Add Key Vault secret with name `kvsecret`
- Restart pod
- App should now reflect value from Key Vault