## Create a Resource Group for Storage
resource "azurerm_resource_group" "rg_avd_storage" {
  location = var.deploy_location
  name     = upper("${var.Customer}${var.avd_storage_resource_group}")
}

# generate a random string (consisting of four characters)
resource "random_string" "random1" {
  length  = 4
  upper   = false
  special = false
}

## Azure Storage Accounts requires a globally unique names
## https://docs.microsoft.com/en-us/azure/storage/common/storage-account-overview
## Create a File Storage Account 
resource "azurerm_storage_account" "avd_prm_storage" {
  name                      = "${var.avd_storage_premium_name}${random_string.random1.id}"
  resource_group_name       = azurerm_resource_group.rg_avd_storage.name
  location                  = azurerm_resource_group.rg_avd_storage.location
  account_tier              = "Premium"
  account_replication_type  = var.avd_storage_premium_replication
  account_kind              = "FileStorage"
  min_tls_version           = "TLS1_2"
  enable_https_traffic_only = true
  access_tier               = "Hot"
  allow_blob_public_access  = false
  large_file_share_enabled  = true
  share_properties {
    retention_policy { 
        days           = 90
    }
  }
  network_rules {
    default_action  = "Deny"
    bypass          = ["AzureServices"]
    ip_rules        = ["1.2.3.4"]    #Pas IP aan
  }
}

#imported account

#resource "azurerm_storage_account" "avd_prem_storage" {
#}

resource "azurerm_storage_share" "fslogixprofiles" {
  name                 = "fslogixprofiles"
  quota                = 100  
  storage_account_name = azurerm_storage_account.avd_prm_storage.name
  depends_on           = [azurerm_storage_account.avd_prm_storage]
}

resource "azurerm_storage_share" "fslogixoffice" {
  name                 = "fslogixoffice"
  quota                = 100  
  storage_account_name = azurerm_storage_account.avd_prm_storage.name
  depends_on           = [azurerm_storage_account.avd_prm_storage]
}

######################################
resource "azurerm_storage_account" "avd_std_storage" {
  name                      = "${var.avd_storage_standard_name}${random_string.random1.id}"
  resource_group_name       = azurerm_resource_group.rg_avd_storage.name
  location                  = azurerm_resource_group.rg_avd_storage.location
  account_tier              = "Standard"
  account_replication_type  = var.avd_storage_standard_replication
  account_kind              = "StorageV2"
  min_tls_version           = "TLS1_2"
  enable_https_traffic_only = true
  access_tier               = "Hot"
  allow_blob_public_access  = false
  large_file_share_enabled  = true
  share_properties {
    retention_policy { 
        days           = 90
    }
  }
  network_rules {
    default_action  = "Deny"
    bypass          = ["AzureServices"]
    ip_rules        = ["1.2.3.4"]   #Pas IP aan
  }
}


resource "azurerm_storage_share" "msixappattach" {
  name                 = "msixappattach"
  quota                = 10  
  storage_account_name = azurerm_storage_account.avd_std_storage.name
  depends_on           = [azurerm_storage_account.avd_std_storage]
}




#Get Storage Subnet indien je bestaande infra wil gebruiken

#data "azurerm_resource_group" "infra_rg" {
#  name = "OLYMPUS-INFRA-WEU-RG"
#}

#data "azurerm_virtual_network" "vnet" {
#  name                = "OLYMPUS-WEU-VNET"
#  resource_group_name = data.azurerm_resource_group.infra_rg.name
#}

#data "azurerm_subnet" "storage_subnet" {
#  name                 = "LANGO-STRG-AVD"
#  virtual_network_name = data.azurerm_virtual_network.vnet.name
#  resource_group_name  = data.azurerm_resource_group.infra_rg.name
#}

#resource "azurerm_private_endpoint" "prmstrgprvtndpnt" {
#  name                = "${azurerm_storage_account.avd_prm_storage.name}prvtndpnt"
#  location            = azurerm_resource_group.rg_avd_storage.location
#  resource_group_name = azurerm_resource_group.rg_avd_storage.name
#  subnet_id           = data.azurerm_subnet.storage_subnet.id

  #private_service_connection {
   # name                              = "${azurerm_storage_account.avd_prm_storage.name}-prvtndpntserviceconnection"
    #private_connection_resource_alias = "example-privatelinkservice.d20286c8-4ea5-11eb-9584-8f53157226c6.centralus.azure.privatelinkservice"
    #is_manual_connection              = false
    #private_connection_resource_id = azurerm_private_link_service.prmstrgprvtndpnt.id
  #}
#}



#####################################
#GET Storage VNet
#data "azurerm_subnet" "avd_vnet_default" {
#  name                 = "LANGO-STRG-AVD"
#  virtual_network_name = "OLYMPUS-WEU-VNET"
#  resource_group_name  = "OLYMPUS-INFRA-WEU-RG"
#}

#locals {
#  pe_subnet_id = data.azurerm_subnet.avd_vnet_default.id
#}

## Azure built-in roles
## https://docs.microsoft.com/en-us/azure/role-based-access-control/built-in-roles
data "azurerm_role_definition" "storage_role" {
  name = "Storage File Data SMB Share Contributor"
}

##resource "azurerm_role_assignment" "af_role" {
## scope              = azurerm_storage_account.storage.id
## role_definition_id = data.azurerm_role_definition.storage_role.id
## principal_id       = azuread_group.aad_group.id
##}