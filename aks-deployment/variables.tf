variable "identifier" {
  default = "app005"
}

variable "resourceGroupName" {
  default = "rg"
}

variable "location" {
  default = "eastus"
}

variable "aksName" {
  default = "aks"
}

variable "continerRegistryName" {
  default     = "acr"
}

variable "keyvaultName" {
  default     = "protemp-kv001"
}

variable "sqlServerName" {
  default     = "sql"
}

variable "sqlServerAdminName" {
  default     = "twtadmin"
}

variable "sqlServerAdminPassword" {
  default     = "Password2020!"
}
