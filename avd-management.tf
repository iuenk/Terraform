resource "azurerm_resource_group" "avd_management_resource_group" {
  location = var.deploy_location
  name     = upper("${var.Customer}${var.avd_management_resource_group}")
}

resource "azurerm_automation_account" "avd_management_account" {
  name                = lower("${var.Customer}${var.avd_automationaccount}")
  location            = azurerm_resource_group.avd_management_resource_group.location
  resource_group_name = azurerm_resource_group.avd_management_resource_group.name

  sku_name = "Basic"

  #tags = {
  #  environment = "avd-prd"
  #}
}

resource "azurerm_log_analytics_workspace" "avd_log-analytics" {
  name                = upper("${var.Customer}-AVD-Log")
  location            = azurerm_resource_group.avd_management_resource_group.location
  resource_group_name = azurerm_resource_group.avd_management_resource_group.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

resource "azurerm_log_analytics_linked_storage_account" "avd_log_analytics_storage" {
  data_source_type      = "customlogs"
  resource_group_name   = azurerm_resource_group.avd_management_resource_group.name
  workspace_resource_id = azurerm_log_analytics_workspace.avd_log-analytics.id
  storage_account_ids   = [azurerm_storage_account.avd_std_storage.id]
}


resource "azurerm_log_analytics_solution" "avd-oms-updates" {
  solution_name         = "Updates"
  location              = azurerm_resource_group.avd_management_resource_group.location
  resource_group_name   = azurerm_resource_group.avd_management_resource_group.name
  workspace_resource_id = azurerm_log_analytics_workspace.avd_log-analytics.id
  workspace_name        = azurerm_log_analytics_workspace.avd_log-analytics.name

  plan {
    publisher = "Microsoft"
    product   = "OMSGallery/Updates"
  }
}

resource "azurerm_log_analytics_solution" "avd_oms_antimalware" {
  solution_name         = "AntiMalware"
  location              = azurerm_resource_group.avd_management_resource_group.location
  resource_group_name   = azurerm_resource_group.avd_management_resource_group.name
  workspace_resource_id = azurerm_log_analytics_workspace.avd_log-analytics.id
  workspace_name        = azurerm_log_analytics_workspace.avd_log-analytics.name

  plan {
    publisher = "Microsoft"
    product   = "OMSGallery/AntiMalware"
  }
}

resource "azurerm_log_analytics_solution" "avd_oms_logicappsmanagement" {
  solution_name         = "LogicAppsManagement"
  location              = azurerm_resource_group.avd_management_resource_group.location
  resource_group_name   = azurerm_resource_group.avd_management_resource_group.name
  workspace_resource_id = azurerm_log_analytics_workspace.avd_log-analytics.id
  workspace_name        = azurerm_log_analytics_workspace.avd_log-analytics.name

  plan {
    publisher = "Microsoft"
    product   = "OMSGallery/LogicAppsManagement"
  }
}

resource "azurerm_log_analytics_solution" "avd_oms_vminsights" {
  solution_name         = "VMInsights"
  location              = azurerm_resource_group.avd_management_resource_group.location
  resource_group_name   = azurerm_resource_group.avd_management_resource_group.name
  workspace_resource_id = azurerm_log_analytics_workspace.avd_log-analytics.id
  workspace_name        = azurerm_log_analytics_workspace.avd_log-analytics.name

  plan {
    publisher = "Microsoft"
    product   = "OMSGallery/VMInsights"
  }
}



