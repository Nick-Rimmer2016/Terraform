# Create Network Security Group
resource "azurerm_network_security_group" "test" {
  name                = "TestSecurityGroup1"
  location            = "${azurerm_resource_group.terra-res.location}"
  resource_group_name = "${azurerm_resource_group.terra-res.name}"
}
# Create Rule to Allow RDP inbound
resource "azurerm_network_security_rule" "rdp" {
  name                        = "rdp-access"
  priority                    = 200
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "3389"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = "${azurerm_resource_group.terra-res.name}"
  network_security_group_name = "${azurerm_network_security_group.test.name}"
}