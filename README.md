Creates an AKS cluster + configurations for hosting the pro-template scaffolding api. Some features:

- AKS is using [POD identity](https://docs.microsoft.com/en-us/azure/aks/operator-best-practices-identity#use-pod-identities) to securely access Azure Key Vault to retrieve connection strings / keys.
- AKS is using an [NGINX ingress controller + cert manager](https://docs.microsoft.com/en-us/azure/aks/ingress-tls) to dynamically generate certificates (Lets Encrypt) and provide TLS termination.
- An Azure Resource Manager Deployment Script resource is used to perform many Azure data-plane configurations (configure pod identity, configure ingress controller).
- Helm is used to deploy the pro-template scaffolding application.

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