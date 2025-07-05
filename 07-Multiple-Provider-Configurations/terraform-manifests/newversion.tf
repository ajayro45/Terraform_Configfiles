terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 4.0.0"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = "003a957e-d556-4b0a-a5d2-60c7135597d7"
}

provider "azurerm" {
  features {
    virtual_machine {
      delete_os_disk_on_deletion = true
    }
  }
  subscription_id = "003a957e-d556-4b0a-a5d2-60c7135597d7"
  alias           = "provider2"
}

resource "azurerm_resource_group" "firstrg" {
  name     = "testrg1"
  location = "West US"
}

resource "azurerm_resource_group" "secondrg" {
  name     = "testrg2"
  location = "East US"
  provider = azurerm.provider2
}