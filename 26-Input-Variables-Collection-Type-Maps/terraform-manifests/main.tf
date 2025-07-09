resource "random_string" "randomstring" {
  length  = 9
  lower   = true
  upper   = false
  special = false
  numeric = false
}


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

resource "azurerm_public_ip" "newpublicip" {
  name                = var.publicip
  location            = var.location_name
  resource_group_name = azurerm_resource_group.testrg.name
  domain_name_label   = "mynewpublicip-${random_string.randomstring.id}"
  sku                 = lookup(var.publicipsku, var.location_name)
  allocation_method   = lookup(var.publicallocationmethod, var.location_name)
}



