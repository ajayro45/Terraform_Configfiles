resource "azurerm_resource_group" "testrg" {
  name     = "myrg"
  location = "East US"
  tags = {
    "env"    = "dev"
    "rgname" = "myrg"
  }
}

resource "random_string" "randomstring" {
  length  = 9
  lower   = true
  special = false
  upper   = false
  numeric = true
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
  #count               = 2
  for_each            = toset(["vm1", "vm2"])
  name                = "testpublicip-${each.key}"
  location            = azurerm_resource_group.testrg.location
  resource_group_name = azurerm_resource_group.testrg.name
  allocation_method   = "Static"
  domain_name_label   = "mypublicip${each.key}-${random_string.randomstring.id}"
  sku                 = "Standard"
  tags = {
    "env"          = "dev"
    "publicipname" = "testpublicip${each.key}"
    "sku"          = "Standard"
  }
  depends_on = [
    azurerm_virtual_network.testvnet,
    azurerm_subnet.testsubnet
  ]
}

resource "azurerm_network_interface" "nic" {
  #count               = 2
  for_each            = toset(["vm1", "vm2"])
  name                = "nic-${each.key}"
  location            = azurerm_resource_group.testrg.location
  resource_group_name = azurerm_resource_group.testrg.name

  ip_configuration {
    name                          = "ipconfig"
    subnet_id                     = azurerm_subnet.testsubnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.testpublicip[each.key].id
  }
  tags = {
    "env"     = "dev"
    "nicname" = "nic${each.key}"
  }
}

resource "azurerm_virtual_machine" "newvm" {
  #count                 = 2
  for_each              = azurerm_network_interface.nic #foreachchaining
  name                  = "testvm-${each.key}"
  location              = azurerm_resource_group.testrg.location
  resource_group_name   = azurerm_resource_group.testrg.name
  network_interface_ids = [ azurerm_network_interface.nic[each.key].id ]
  vm_size               = "Standard_D2ls_v6"
  os_profile {
    admin_username = "azureuser"
    computer_name  = "devlinuxvm-${each.key}"
    custom_data    = filebase64("${path.module}/app-scripts/app1-cloud-init.txt")
  }
  storage_image_reference {
    publisher = "RedHat"
    offer     = "RHEL-HA"
    sku       = "8_10-gen2"
    version   = "latest"
  }
  os_profile_linux_config {
    ssh_keys {
      path     = "/home/azureuser/.ssh/authorized_keys"
      key_data = file("${path.module}/ssh-keys/terraform-azure.pub")
    }
    disable_password_authentication = true
  }
  storage_os_disk {
    name          = "osdisk${each.key}"
    create_option = "FromImage"
    caching       = "ReadWrite"
    disk_size_gb  = 64
  }

  tags = {
    "env"    = "dev"
    "vmname" = "testvm${each.key}"
  }
}

