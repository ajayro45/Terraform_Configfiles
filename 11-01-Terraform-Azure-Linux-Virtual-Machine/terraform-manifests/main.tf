resource "random_string" "randomstring" {
  length  = 9
  lower   = true
  special = false
  upper   = false
  numeric = true
}

resource "azurerm_resource_group" "testrg" {
  name     = "testrg1"
  location = "East US"
  tags = {
    "env"             = "dev"
    "rgname"          = "testrg1"
    "envvalue"        = "I006"
    "engagement_code" = "6I900"
    "service"         = "123"
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
  domain_name_label   = "mypublicip-${random_string.randomstring.id}"
  sku                 = "Standard"
  tags = {
    "env"          = "dev"
    "publicipname" = "testpublicip1"
    "sku"          = "Standard"
  }
  depends_on = [
    azurerm_virtual_network.testvnet,
    azurerm_subnet.testsubnet
  ]
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

resource "azurerm_virtual_machine" "newvm" {
  name = "testvm"
  location = azurerm_resource_group.testrg.location
  resource_group_name = azurerm_resource_group.testrg.name
  network_interface_ids = [ azurerm_network_interface.nic.id ]
  vm_size = "Standard_D2ls_v6"
  os_profile {
    admin_username = "azureuser"
    computer_name = "devlinuxvm-1"
    custom_data = filebase64("${path.module}/app-scripts/app1-cloud-init.txt")
    }
  storage_image_reference {
    publisher = "RedHat"
    offer     = "RHEL-HA"
    sku       = "8_10-gen2"
    version   = "latest"
  }
  os_profile_linux_config {
    ssh_keys { 
     path = "/home/azureuser/.ssh/authorized_keys"
     key_data = file("${path.module}/ssh-keys1/terraform-azure.pub")
    }
    disable_password_authentication = true
  }
  storage_os_disk {
    name = "osdisk"
    create_option = "FromImage"
    caching = "ReadWrite"
    disk_size_gb = 64
  }
  
  tags = { 
    "env" = "dev"
    "vmname" = "testvm"
  }
}