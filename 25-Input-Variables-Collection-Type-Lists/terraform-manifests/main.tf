resource "azurerm_resource_group" "testrg" {
  name     = "${var.business_unit}-${var.environment}-${var.resource_group_name}"
  location = var.location_name
  tags = {
    "env"    = var.environment
    "rgname" = var.resource_group_name
  }
}


resource "azurerm_virtual_network" "testvnet" {
  name                = "${var.business_unit}-${var.environment}-${var.virtual_network}"
  location            = azurerm_resource_group.testrg.location
  address_space       = var.virtual_network_address_space
  resource_group_name = azurerm_resource_group.testrg.name
  tags = {
    "env"      = var.environment
    "vnetname" = var.virtual_network
    "envvalue" = "I006"
  }
}



