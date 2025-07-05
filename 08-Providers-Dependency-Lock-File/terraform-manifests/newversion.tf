terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 4.0.0"
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 3.0.0"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = "003a957e-d556-4b0a-a5d2-60c7135597d7"
}

provider "random" {

}

resource "random_string" "randomname" {
  length   = 6
  upper    = false
  special  = false
}

resource "azurerm_resource_group" "newrg" {
  name     = "testrg08"
  location = "East US"
  tags = {
    "env" = "dev"
  }
}

resource "azurerm_storage_account" "newsa" {
  name                     = "mysa${random_string.randomname.id}"
  location                 = azurerm_resource_group.newrg.location
  resource_group_name      = azurerm_resource_group.newrg.name
  account_tier             = "Standard"
  account_replication_type = "LRS"
  tags                     = azurerm_resource_group.newrg.tags
}