terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "2.41.0"
    }
  }
}
provider "azurerm" {
  features {

  }
}
resource "azurerm_resource_group" "rg" {
  name     = "rgacmecompany"
  location = "uksouth"
}
resource "azurerm_virtual_network" "rg" {
  name                = "rg-network"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}
resource "azurerm_subnet" "rg" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.rg.name
  address_prefixes     = ["10.0.2.0/24"]
}
resource "azurerm_public_ip" "rg" {
  count               = 2
  name                = "AZ-VM-00-PUBLIC-IP-${count.index}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  allocation_method   = "Dynamic"
  sku                 = "basic"
}
resource "azurerm_network_interface" "rg" {
  count               = 2
  name                = "AZ-VM-00-NIC-${count.index}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.rg.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = element(azurerm_public_ip.rg.*.id, count.index + 1)
  }

}
resource "azurerm_network_security_group" "rg" {
  name                = "AZ-VM-NSG"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  # Security rule can also be defined with resource azurerm_network_security_rule, here just defining it inline.
  security_rule {
    name                       = "Inbound"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  tags = {
    environment = "NSG"
  }
}

resource "azurerm_subnet_network_security_group_association" "rg_nsg_association" {
  subnet_id                 = azurerm_subnet.rg.id
  network_security_group_id = azurerm_network_security_group.rg.id
}

resource "azurerm_windows_virtual_machine" "rg" {
  count               = 2
  name                = "AZ-VM-00-${count.index}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  size                = "Standard_F2"
  admin_username      = "adminata"
  admin_password      = "password"
  network_interface_ids = [
    azurerm_network_interface.rg.*.id[count.index],
  ]
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }
}
