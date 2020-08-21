# AKS > Key Vault Demos

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

## .Net Core Key Vault configuration provider

[Documentation](https://docs.microsoft.com/en-us/aspnet/core/security/key-vault-configuration?view=aspnetcore-3.1)

*Demo Steps**

- Show app and Key Vault configuration provider code
- Run app locally
- Show appsettings.ini
- Run Helm chart
- App should use the value from appsettings.json
- Add Key Vault secret with name `kvsecret`
- Restart pod
- App should now reflect value from Key Vault