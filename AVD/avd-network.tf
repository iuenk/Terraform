resource "azurerm_resource_group" "vnet_rg" {
  name                = "${upper(var.Customer)}-INFRA-WEU-RG"
  location            = var.deploy_location
}

resource "azurerm_virtual_network" "vnet" {
  name                = "${upper(var.Customer)}-WEU-VNET"
  address_space       = ["10.1.0.0/21"]
  #dns_servers         = ["10.1.1.20"]
  location            = azurerm_resource_group.vnet_rg.location
  resource_group_name = azurerm_resource_group.vnet_rg.name
  depends_on          = [azurerm_resource_group.vnet_rg]
}

resource "azurerm_subnet" "adds_sbnt" {
  name                 = "ADDS-SBNT"
  resource_group_name  = azurerm_resource_group.vnet_rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.1.1.0/28"]
  depends_on           = [azurerm_resource_group.vnet_rg]
}

resource "azurerm_subnet" "avd_sbnt" {
  name                 = "AVD-SBNT"
  resource_group_name  = azurerm_resource_group.vnet_rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.1.1.16/28"]
  depends_on           = [azurerm_resource_group.vnet_rg]
}

resource "azurerm_subnet" "strg_sbnt" {
  name                 = "STORAGE-SBNT"
  resource_group_name  = azurerm_resource_group.vnet_rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.1.1.32/28"]
  enforce_private_link_endpoint_network_policies = true
  depends_on           = [azurerm_resource_group.vnet_rg]
}

resource "azurerm_network_security_group" "nsg" {
  name                = "${upper(var.Customer)}-WEU-NSG"
  location            = azurerm_resource_group.vnet_rg.location
  resource_group_name = azurerm_resource_group.vnet_rg.name
  security_rule {
    name                       = "RDP"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "1.2.3.4/32"  #Pas IP aan
    destination_address_prefix = "*"
  }
  depends_on = [azurerm_resource_group.vnet_rg]
}


resource "azurerm_subnet_network_security_group_association" "adds_sbnt_nsg" {
  subnet_id                 = azurerm_subnet.adds_sbnt.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}

resource "azurerm_subnet_network_security_group_association" "avd_sbnt_nsg" {
  subnet_id                 = azurerm_subnet.avd_sbnt.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}

resource "azurerm_subnet_network_security_group_association" "strg_sbnt_nsg" {
  subnet_id                 = azurerm_subnet.strg_sbnt.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}
