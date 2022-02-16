# Customized the sample values below for your environment and either rename to terraform.tfvars or env.auto.tfvars

Customer                        = "UCORP"
deploy_location                 = "west europe"
avd_std_resource_group          = "AVD-RESOURCES-RG"
avd_storage_resource_group      = "-AVD-STORAGE-RG"
avd_keyvault_resource_group     = "-AVD-KEYVAULT-RG"
avd_std_vm_resource_group       = "-AVD-HOST-STD-RG"
avd_management_resource_group   = "-AVD-MANAGEMENT-RG"
avd_resource_group              = "-AVD-RG"
avd_storage_premium_name        = "ucorpprem"
avd_storage_premium_replication = "LRS"
avd_storage_standard_name        = "ucorpstd"
avd_storage_standard_replication = "LRS"
avd_keyvault_name               = "-AVD-KV"
avd_std_workspace               = "-STD-WORKSPACE"
avd_std_hostpool                = "-STD-HOSTPOOL"
avd_std_vm_count                = 1
avd_std_max_user                = 8
avd_std_pool_type               = "Pooled"
avd_std_lbpool_type             = "DepthFirst"
avd_std_prefix                  = "-AVD"
avd_std_vmsize                  = "Standard_D4s_v3"
avd_automationaccount           = "-AVD-AA"
local_admin_username            = "ucorpadmin"
local_admin_password            = "<Password>"
vnet_range                      = ["10.1.0.0/16"]
subnet_range                    = ["10.1.0.0/24"]
dns_servers                     = ["10.0.1.4", "168.63.129.16"]
aad_group_name                  = "SG_AVD_Users"
domain_name                     = "ucorp.local"
domain_user_upn                 = "svc_adjoin"     # do not include domain name as this is appended
#domain_password                 = "xxxxx"
avd_ou_path                     = "OU=AVD,OU=Ucorp,DC=ucorp,DC=local"
ad_vnet                         = "-AVD-VNET"
ad_rg                           = "-INFRA-RG"
avd_users = [
  #"avduser01@infra.local",
  #"avduser01@infra.local"
]