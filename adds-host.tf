locals {
  password_command = "$password = ConvertTo-SecureString 'P@$$w0rd1234!' -AsPlainText -Force"
  adjoin_password = "$adJoinPass = ConvertTo-SecureString ${var.domain_password} -AsPlainText -Force"
  #credentials_command  = "New-Object System.Management.Automation.PSCredential('myadmin', $password)"
  install_ad_command   = "Add-WindowsFeature -name ad-domain-services -IncludeManagementTools"
  configure_ad_command = "Install-ADDSForest -DomainName 'auth.langoworkspace.com' -DomainMode 'WinThreshold' -ForestMode 'WinThreshold' -DomainNetbiosName 'LANGO' -InstallDns -NoRebootOnCompletion -SafeModeAdministratorPassword $password -Force:$true"
  shutdown_command     = "shutdown -r -t 10"
  exit_code_hack       = "exit 0"
  #create_lango_ou      = "New-ADOrganizationalUnit -Name 'Lango' -Path 'DC=auth,DC=langoworkspace,DC=com'"  #Pas "azurerm_virtual_machine_extension" "setup-prereqs" aan
  #create_avd_ou        = "New-ADOrganizationalUnit -Name 'AVD' -Path 'OU=Lango,DC=auth,DC=langoworkspace,DC=com'"
  #create_adjoin        = "New-ADUser -Name 'AdJoin' -AccountPassword $adJoinPass -PasswordNeverExpires $true -Enabled $true"
  create_sec_aadusers  = ""
  #add_administrators   = "Add-ADGroupMember -Identity 'Administrators' -Members 'adJoin'"
  powershell_command   = " ${local.password_command};${local.install_ad_command}; ${local.configure_ad_command}; ${local.shutdown_command}; ${local.exit_code_hack}"
  #setupprereqs_command   = " ${local.adjoin_password};${local.create_lango_ou}; ${local.create_avd_ou}; ${local.create_adjoin}; ${local.add_administrators}; ${local.exit_code_hack}"
}

resource "azurerm_resource_group" "adds_resource_group" {
  name     = "${upper(var.Customer)}-ADDS-WEU-RG"
  location = var.deploy_location
}

resource "azurerm_network_interface" "adds_nic" {
  name                  = "${upper(var.Customer)}DC-NIC"
  location              = azurerm_resource_group.adds_resource_group.location
  resource_group_name   = azurerm_resource_group.adds_resource_group.name
  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.adds_sbnt.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id  = azurerm_public_ip.adds_nic_pip.id
  }
  depends_on            = [azurerm_subnet.adds_sbnt]
  dns_servers           =  ["127.0.0.1"]
}

resource "azurerm_public_ip" "adds_nic_pip" {
  name                = "${upper(var.Customer)}DC-NIC-PIP"
  resource_group_name = azurerm_resource_group.adds_resource_group.name
  location            = azurerm_resource_group.adds_resource_group.location
  allocation_method   = "Dynamic"
}

resource "azurerm_windows_virtual_machine" "adds_vm" {
  name                = "${upper(var.Customer)}DC"
  resource_group_name = azurerm_resource_group.adds_resource_group.name
  location            = azurerm_resource_group.adds_resource_group.location
  size                = "Standard_F2"
  admin_username      = "myadmin"
  admin_password      = "P@$$w0rd1234!"
  network_interface_ids = [
    azurerm_network_interface.adds_nic.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2022-Datacenter"
    version   = "latest"
  }
}

resource "azurerm_virtual_machine_extension" "install-forest" {
  name                 = "install-forest"
  virtual_machine_id =  azurerm_windows_virtual_machine.adds_vm.id
  publisher            = "Microsoft.Compute"
  type                 = "CustomScriptExtension"
  type_handler_version = "1.9"

  settings = <<SETTINGS
    {
        "commandToExecute": "powershell.exe -Command \"${local.powershell_command}\""
    }
SETTINGS
}

#resource "azurerm_virtual_machine_extension" "setup-prereqs" {
#  name                 = "setup-prereqs"
#  virtual_machine_id =  azurerm_windows_virtual_machine.adds_vm.id
#  publisher            = "Microsoft.Compute"
#  type                 = "CustomScriptExtension"
#  type_handler_version = "1.9"
#
#  settings = <<SETTINGS
#    {
#        "commandToExecute": "powershell.exe -Command \"${local.setupprereqs_command}\""
#    }
#SETTINGS
  #depends_on          =  [azurerm_virtual_machine_extension.install-forest]
#}