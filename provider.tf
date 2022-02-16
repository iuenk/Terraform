terraform {    
    backend "azurerm" {
    resource_group_name   = "Ucorp-Storage-RG"
    storage_account_name  = "ucorptfstd"
    container_name        = "terraformstate"
    key                   = "uA7gqY1DfZUvKSFUCoxKVkQqNb7igH3tLC5jXqr3l3Z/zY6XE5/zeKc9a3N+SJ7dNT3Xv2dAbtRc1dYO8pD7Bg=="

  }
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "2.90.0"
    }
    azuread = {
      source = "hashicorp/azuread"
    }
  }
}

provider "azurerm" {
  features {
    key_vault {
      #purge_soft_delete_on_destroy = true
    }
  }
}