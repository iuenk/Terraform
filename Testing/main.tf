terraform {
  backend "azurerm" {
    resource_group_name  = "Ucorp-Storage-RG"
    storage_account_name = "ucorpstorage"
    container_name       = "tfstatefile"
    key                  = "dev.terraform.tfstate"
  }
}
module "RG" {
  source   = "./modules/RG"
  rgname   = var.rgname
  location = var.location
}

module "SA" {
  source   = "./modules/SA"
  sname    = var.sname
  rgname   = var.rgname
  location = var.location
}