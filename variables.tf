variable "Customer" {
  type        = string
  description = "Customer name"
}

variable "avd_std_resource_group" {
  type        = string
  description = "Name of the Resource group in which to deploy these AVD resources"
}

variable "avd_storage_resource_group" {
  type        = string
  description = "Name of the Resource group in which to deploy these storage resources"
}

variable "avd_keyvault_resource_group" {
  type        = string
  description = "Name of the Resource group in which to deploy these storage resources"
}

variable "avd_keyvault_name" {
  type        = string
  description = "Name of the premium storage account used for fslogix storage"
}

variable "avd_storage_premium_name" {
  type        = string
  description = "Name of the premium storage account used for fslogix storage"
}

variable "avd_storage_premium_replication" {
  type        = string
  description = "AVD Storage Replication Type"
}

variable "avd_storage_standard_name" {
  type        = string
  description = "Name of the premium storage account used for fslogix storage"
}

variable "avd_storage_standard_replication" {
  type        = string
  description = "AVD Storage Replication Type"
}

variable "deploy_location" {
  type        = string
  description = "The Azure Region in which all resources in this example should be created."
}

variable "avd_resource_group" {
  type        = string
  description = "Name of the Resource group in which to deploy these storage resources"
}

variable "avd_std_vm_resource_group" {
  type        = string
  description = "Name of the Resource group in which to deploy these storage resources"
}

variable "avd_management_resource_group" {
  type        = string
  description = "Name of the Resource group in which to deploy these storage resources"
}
variable "avd_std_workspace" {
  type        = string
  description = "Name of the Azure Virtual Desktop workspace"
  default     = "LANGO AVD Default desktop"
}

variable "avd_std_hostpool" {
  type        = string
  description = "Name of the Azure Virtual Desktop host pool"
  default     = "LANGO-STD-POOL"
}

variable "ad_vnet" {
  type        = string
  description = "Name of domain controller vnet"
}

variable "dns_servers" {
  type        = list(string)
  description = "Custom DNS configuration"
}

variable "vnet_range" {
  type        = list(string)
  description = "Address range for deployment VNet"
}
variable "subnet_range" {
  type        = list(string)
  description = "Address range for session host subnet"
}

variable "ad_rg" {
  type        = string
  description = "The resource group for AD VM"
}

variable "avd_users" {
  description = "AVD users"
  default     = []
}

variable "aad_group_name" {
  type        = string
  description = "Azure Active Directory Group for AVD users"
}

variable "avd_std_max_user" {
  description = "Max number of users per VM"
  default     = 8
}

variable "avd_std_vm_count" {
  description = "Number of AVD machines to deploy"
  default     = 1
}

variable "avd_std_pool_type" {
  type = string
  description = "Specify Personal of Pooled type"
  validation {
    condition = anytrue([
      var.avd_std_pool_type == "Personal",
      var.avd_std_pool_type == "Pooled"
    ])
    error_message = "Must be a valid avd_std_pool_type, allowed values are Personal or Pooled."
  }
}

variable "avd_std_lbpool_type" {
  type = string
  description = "Loadbalance mechanism BreadthFirst or DepthFirst"
  validation {
    condition = anytrue([
      var.avd_std_lbpool_type == "BreadthFirst",
      var.avd_std_lbpool_type == "DepthFirst"
    ])
    error_message = "Must be a valid avd_std_lbpool_type, allowed values are BreadthFirst or DepthFirst."
  }
}

variable "avd_std_prefix" {
  type        = string
  description = "Prefix of the name of the AVD machine(s)"
}

variable "avd_automationaccount" {
  type        = string
  description = "AVD Automation Account"
}

variable "domain_name" {
  type        = string
  description = "Name of the domain to join"
}

variable "domain_user_upn" {
  type        = string
  description = "Username for domain join (do not include domain name as this is appended)"
}

variable "domain_password" {
  type        = string
  description = "Password of the user to authenticate with the domain"
  sensitive   = true
}

variable "avd_std_vmsize" {
  description = "Size of the machine to deploy"
  default     = "Standard_DS2_v3"
}

variable "avd_ou_path" {
  default = ""
}

variable "local_admin_username" {
  type        = string
  description = "local admin username"
}

variable "local_admin_password" {
  description = "local admin password"
  sensitive   = true
}