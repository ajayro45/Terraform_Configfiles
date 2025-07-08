resource "azurerm_resource_group" "myrgtest" {
  for_each = {
    testrg1 = "East US"
    testrg2 = "Central US"
    testrg3 = "West US 2"
  }
  name     = "my${each.key}"
  location = each.value
}