# AKS > Key Vault Demos

## Quickstart

Ensure both the Azure CLI, Terraform, and Docker are installed on your development system and that the Azure CLI is authenticated with Azure.

Run these commands to deploy / configure the infrastructure. When prompted, type 'yes' and hit enter.

```
terraform init deploy/terraform/
terraform apply deploy/terraform/
```

## Azure Key Vault Configuration Provider in ASP.NET Core

Loads app configuration values from Azure Key Vault secrets.

- Control access to sensitive configuration data
- Meets FIPS 140-2 Level 2 validated Hardware Security Module
- Using [Azure Active Directory Pod Identity](https://github.com/Azure/aad-pod-identity) for Key Vault access
- nuget package - https://www.nuget.org/packages/Microsoft.Extensions.Configuration.AzureKeyVault/
- Documentation - https://docs.microsoft.com/en-us/aspnet/core/security/key-vault-configuration?view=aspnetcore-3.1

.NET Configuration manager precedence

- JSON, XL, INI
- Command-line arguments
- Environment variables
- In-memory .NET objects
- Secret Manager storage
- Encrypted in Azure Key Vault

## Container Storage Interface (CSI) driver for Azure

Get values from Azure Key Vault and mount them into Kubernetes pods.

- Mounts secrets, keys, and certificates as [Container Storage Interface (CSI) volumes](https://github.com/kubernetes-sigs/secrets-store-csi-driver)
- Mount multiple secrets as a single volume
- Using [Azure Active Directory Pod Identity](https://github.com/Azure/aad-pod-identity) for Key Vault access
- Supports sync with Kubernetes Secrets 

**Installation**

```
helm repo add csi-secrets-store-provider-azure https://raw.githubusercontent.com/Azure/secrets-store-csi-driver-provider-azure/master/charts
helm install csi-secrets-store-provider-azure/csi-secrets-store-provider-azure --generate-name
```