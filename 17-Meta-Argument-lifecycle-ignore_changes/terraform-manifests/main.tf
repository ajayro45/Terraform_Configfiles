resource "azurerm_resource_group" "testrg" {
  name     = "myrg"
  location = "East US"
  tags = {
    "env"    = "dev"
    "rgname" = "myrg"
  }
}


resource "azurerm_virtual_network" "testvnet" {
  name                = "testvnet1"
  location            = azurerm_resource_group.testrg.location
  address_space       = ["10.0.0.0/16"]
  resource_group_name = azurerm_resource_group.testrg.name
  tags = {
    "env"      = "dev"
    "vnetname" = "testvnet1"
    "envvalue" = "I006"
    "testtag"  = "testone"
  }
  lifecycle {
    ignore_changes = [tags]
  }
}

resource "azurerm_subnet" "testsubnet" {
  name                 = "testsubnet1"
  virtual_network_name = azurerm_virtual_network.testvnet.name
  resource_group_name  = azurerm_resource_group.testrg.name
  address_prefixes     = ["10.0.1.0/24"]
}



