resource "azurerm_resource_group" "testrg" {
  name     = "testrg1"
  location = "North Europe"
  tags = {
    "env"    = "dev"
    "rgname" = "testrg1"
    "envvalue" = "I006"
    "engagement_code" = "6I900"
    "service" = "123"
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
  }
}

resource "azurerm_subnet" "testsubnet" {
  name                 = "testsubnet1"
  virtual_network_name = azurerm_virtual_network.testvnet.name
  resource_group_name  = azurerm_resource_group.testrg.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_public_ip" "testpublicip" {
  name                = "testpublicip1"
  location            = azurerm_resource_group.testrg.location
  resource_group_name = azurerm_resource_group.testrg.name
  allocation_method   = "Static"
  sku = "Standard"
  tags = {
    "env"          = "dev"
    "publicipname" = "testpublicip1"
    "sku" = "Standard"
  }
}

resource "azurerm_network_interface" "nic" {
  name                = "nic1"
  location            = azurerm_resource_group.testrg.location
  resource_group_name = azurerm_resource_group.testrg.name

  ip_configuration {
    name                          = "ipconfig"
    subnet_id                     = azurerm_subnet.testsubnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.testpublicip.id
  }
  tags = {
    "env"     = "dev"
    "nicname" = "nic1"
  }
}