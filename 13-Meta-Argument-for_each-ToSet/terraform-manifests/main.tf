resource "azurerm_resource_group" "myrgtest" {
  for_each = toset(["eastus", "centralus", "westus2"])
  name     = "my${each.key}rg"
  location = each.value
}