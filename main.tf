provider "azurerm" {
  features {}
}

# Data sources to fetch existing VPC and Subnet
data "azurerm_virtual_network" "DemoVN" {
  name                = "DemoVN"
  resource_group_name = "kehinderg"
}

data "azurerm_subnet" "default" {
  name                 = "default"
  virtual_network_name = data.azurerm_virtual_network.DemoVN.name
  resource_group_name  = data.azurerm_virtual_network.kehinderg.resource_group_name
}

data "azurerm_resource_group" "kehinderg" {
  name     = "kehinderg"
  location = "East US"
}

resource "azurerm_network_security_group" "Demo-SG" {
  name                = "Demo-SG"
  location            = azurerm_resource_group.kehinderg.location
  resource_group_name = azurerm_resource_group.kehinderg.name

  security_rule {
    name                       = "HTTP"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_public_ip" "Demo-IP" {
  name                = "Demo-IP"
  location            = azurerm_resource_group.kehinderg.location
  resource_group_name = azurerm_resource_group.kehinderg.name
  allocation_method   = "Dynamic"
}

resource "azurerm_network_interface" "Demo-NI" {
  name                = "Demo-NI"
  location            = azurerm_resource_group.kehinderg.location
  resource_group_name = azurerm_resource_group.kehinderg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = data.azurerm_subnet.default.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.Demo-IP.id
  }
}

resource "azurerm_network_interface_security_group_association" "Demo-NISG" {
  network_interface_id      = azurerm_network_interface.Demo-NI.id
  network_security_group_id = azurerm_network_security_group.Demo-SG.id
}

resource "azurerm_virtual_machine" "Demo-VM-terraform" {
  name                  = "Demo-VM-terraform"
  location              = azurerm_resource_group.kehinderg.location
  resource_group_name   = azurerm_resource_group.kehinderg.name
  network_interface_ids = [azurerm_network_interface.Demo-NI.id]
  vm_size               = "Standard_DS1_v2"

  delete_os_disk_on_termination = true

  storage_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }

  storage_os_disk {
    name              = "Demo-os-disk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name  = "hostname"
    admin_username = "adminuser"
    admin_password = "AdminPassword123!"
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }

  tags = {
    environment = "Testing"
  }
}
