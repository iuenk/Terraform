resource "azurerm_storage_account" "sa" {
  name                     = var.sname
  resource_group_name      = var.rgname
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
    environment = "dev"
  }

  depends_on = [azurerm_resource_group]
}
