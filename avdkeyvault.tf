data "azurerm_client_config" "current" {}

resource "azurerm_resource_group" "avdkeyvault" {
  name     = upper("${var.Customer}${var.avd_keyvault_resource_group}")
  location = var.deploy_location
}

resource "azurerm_key_vault" "avdkeyvault" {
  name                        = lower("${var.Customer}${var.avd_keyvault_name}${random_string.random1.id}")
  location                    = azurerm_resource_group.avdkeyvault.location
  resource_group_name         = azurerm_resource_group.avdkeyvault.name
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = 30
  purge_protection_enabled    = false

  sku_name = "standard"

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    key_permissions = [
      "Get",
    ]

    secret_permissions = [
      "Get","Set","Delete","List","Recover"
    ]

    storage_permissions = [
      "Get",
    ]
  }
}

resource "random_string" "avd_admin_local_password1" {
  #count            = var.avd_std_vm_count
  length           = 16
  special          = true
  min_special      = 2
  override_special = "*!@#?"
}

resource "azurerm_key_vault_secret" "avd_admin_local_password" {
  name         = "avd-local-secret"
  value        = random_string.avd_admin_local_password1.id
  key_vault_id = azurerm_key_vault.avdkeyvault.id
}


data "azurerm_key_vault" "avdkeyvault" {
  name                = azurerm_key_vault.avdkeyvault.name
  resource_group_name = azurerm_key_vault.avdkeyvault.resource_group_name
}

data "azurerm_key_vault_secret" "avd_admin_local_password" {
  name         = azurerm_key_vault_secret.avd_admin_local_password.name
  key_vault_id = azurerm_key_vault.avdkeyvault.id
  #sensitive = true
  depends_on   = [azurerm_key_vault_secret.avd_admin_local_password]
}

#data "azurerm_key_vault_secret" "adJoin_password" {
#  name         = "avd-adjoin-password"
#  key_vault_id = azurerm_key_vault.avdkeyvault.id
  #sensitive = true
#}