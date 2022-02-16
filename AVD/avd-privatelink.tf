resource "azurerm_private_endpoint" "avd_prm_storage" {
  name                = "${azurerm_storage_account.avd_prm_storage.name}-private-endpoint"
  location            = azurerm_resource_group.rg_avd_storage.location
  resource_group_name = azurerm_resource_group.rg_avd_storage.name
  subnet_id           = azurerm_subnet.strg_sbnt.id

  private_service_connection {
    name                           = "storage-privateserviceconnection"
    private_connection_resource_id = azurerm_storage_account.avd_prm_storage.id
    subresource_names              = [ "file" ]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name = "storage-privateserviceconnection"
    private_dns_zone_ids = [azurerm_private_dns_zone.dns_zone_privatelink_file.id]
  }
}

resource "azurerm_private_endpoint" "avd_std_storage" {
  name                = "${azurerm_storage_account.avd_std_storage.name}-private-endpoint"
  location            = azurerm_resource_group.rg_avd_storage.location
  resource_group_name = azurerm_resource_group.rg_avd_storage.name
  subnet_id           = azurerm_subnet.strg_sbnt.id

  private_service_connection {
    name                           = "storage-privateserviceconnection"
    private_connection_resource_id = azurerm_storage_account.avd_std_storage.id
    subresource_names              = [ "file" ]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name = "storage-privateserviceconnection"
    private_dns_zone_ids = [azurerm_private_dns_zone.dns_zone_privatelink_file.id]
  }
}