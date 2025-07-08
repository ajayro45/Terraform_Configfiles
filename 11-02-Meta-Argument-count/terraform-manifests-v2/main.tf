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
  count               = 2
  name                = "testpublicip-${count.index}"
  location            = azurerm_resource_group.testrg.location
  resource_group_name = azurerm_resource_group.testrg.name
  allocation_method   = "Static"
  domain_name_label   = "mypublicip${count.index}-${random_string.randomstring.id}"
  sku                 = "Standard"
  tags = {
    "env"          = "dev"
    "publicipname" = "testpublicip${count.index}"
    "sku"          = "Standard"
  }
  depends_on = [
    azurerm_virtual_network.testvnet,
    azurerm_subnet.testsubnet
  ]
}

resource "azurerm_network_interface" "nic" {
  count               = 2
  name                = "nic-${count.index}"
  location            = azurerm_resource_group.testrg.location
  resource_group_name = azurerm_resource_group.testrg.name

  ip_configuration {
    name                          = "ipconfig"
    subnet_id                     = azurerm_subnet.testsubnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = element(azurerm_public_ip.testpublicip[*].id, count.index)
  }
  tags = {
    "env"     = "dev"
    "nicname" = "nic${count.index}"
  }
}

resource "azurerm_virtual_machine" "newvm" {
  count                 = 2
  name                  = "testvm-${count.index}"
  location              = azurerm_resource_group.testrg.location
  resource_group_name   = azurerm_resource_group.testrg.name
  network_interface_ids = [element(azurerm_network_interface.nic[*].id, count.index)]
  vm_size               = "Standard_D2ls_v6"
  os_profile {
    admin_username = "azureuser"
    computer_name  = "devlinuxvm-${count.index}"
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
    name          = "osdisk${count.index}"
    create_option = "FromImage"
    caching       = "ReadWrite"
    disk_size_gb  = 64
  }

  tags = {
    "env"    = "dev"
    "vmname" = "testvm${count.index}"
  }
}

