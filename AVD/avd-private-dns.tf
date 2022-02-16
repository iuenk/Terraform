#################################################################
resource "azurerm_private_dns_zone" "dns_zone_privatelink_file" {
  name                = "privatelink.file.core.windows.net"
  resource_group_name = azurerm_resource_group.vnet_rg.name
}

#resource "azurerm_private_dns_a_record" "example" {
#  name                = "test"
#  zone_name           = azurerm_private_dns_zone.example.name
#  resource_group_name = azurerm_resource_group.example.name
#  ttl                 = 300
#  records             = ["10.0.180.17"]
#}