param(
  [string] [Parameter(Mandatory=$true)] $sqlServer,
  [string] [Parameter(Mandatory=$true)] $sqlAdmin,
  [string] [Parameter(Mandatory=$true)] $sqlPassword,
  [string] [Parameter(Mandatory=$true)] $aksCluster,
  [string] [Parameter(Mandatory=$true)] $aksResourceGroup,
  [string] [Parameter(Mandatory=$true)] $aksNodeResourceGroup
)

# Connect to AKS Cluster
bash -c "curl -sL https://aka.ms/InstallAzureCLIDeb | bash"
bash -c "az login --identity"
bash -c "az aks install-cli"
bash -c "az aks get-credentials --name $aksCluster --resource-group $aksResourceGroup"

# Configure POD Identity
bash -c "kubectl apply -f https://raw.githubusercontent.com/Azure/aad-pod-identity/master/deploy/infra/deployment-rbac.yaml"
bash -c "kubectl apply -f https://raw.githubusercontent.com/Azure/aad-pod-identity/master/deploy/infra/mic-exception.yaml"

# Install Helm
bash -c "curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3"
bash -c "chmod 700 get_helm.sh"
bash -c "./get_helm.sh"

# Install NGINX Ingress Controller
bash -c "kubectl create namespace ingress-basic"
bash -c "helm repo add stable https://kubernetes-charts.storage.googleapis.com/"
bash -c "helm install nginx stable/nginx-ingress"

# Get Ingress IP Address
DO {
  $ip = az network public-ip list --resource-group $aksNodeResourceGroup --query [].ipAddress -o tsv
} Until ($ip)

$PUBLICIPID=$(az network public-ip list --query "[?ipAddress!=null]|[?contains(ipAddress, '$ip')].[id]" --output tsv)

# Add DNS Record
bash -c "az network public-ip update --ids $PUBLICIPID --dns-name $aksCluster"

# Install cert manager
bash -c "kubectl apply --validate=false -f https://raw.githubusercontent.com/jetstack/cert-manager/release-0.13/deploy/manifests/00-crds.yaml"
bash -c "kubectl label namespace ingress-basic cert-manager.io/disable-validation=true"
bash -c "helm repo add jetstack https://charts.jetstack.io"
bash -c "helm repo update"
bash -c "helm install cert-manager --version v0.13.0 jetstack/cert-manager"

# Install Secret Store CSI driver
bash -c "helm repo add csi-secrets-store-provider-azure https://raw.githubusercontent.com/Azure/secrets-store-csi-driver-provider-azure/master/charts"
bash -c "helm install csi-secrets-store-provider-azure/csi-secrets-store-provider-azure --generate-name"