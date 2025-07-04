terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.35.0"
    }
  }
}

provider "azurerm" {
  # Configuration options
  features {}
  subscription_id = "003a957e-d556-4b0a-a5d2-60c7135597d7"
}

resource "azurerm_resource_group" "my_demo_rg1" {
  name     = "testaishurg"
  location = "West Europe"
}