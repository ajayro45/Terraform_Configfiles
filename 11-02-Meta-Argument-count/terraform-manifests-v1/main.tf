resource "azurerm_resource_group" "myrg1" {
  count = 2
  name = "myrg-${count.index}"
  location = "East US"
  tags = { 
    "env" = "dev"
    "rgname" = "myrg-${count.index}"
  }
}
