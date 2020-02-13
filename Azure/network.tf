# Create a virtual network within the resource group
resource "azurerm_virtual_network" "terra-net" {
name = "production-network"
address_space = ["10.0.0.0/16"]
location = "${azurerm_resource_group.terra-res.location}"
resource_group_name = "${azurerm_resource_group.terra-res.name}"
}
# Create subnets
resource "azurerm_subnet" "terra-subnet-1" {
name = "prod-subnet-1"
resource_group_name = "${azurerm_resource_group.terra-res.name}"
virtual_network_name="${azurerm_virtual_network.terra-net.name}"
address_prefix = "10.0.1.0/24"
}
# Associate SubNet with Network Security Group
resource "azurerm_subnet_network_security_group_association" "test" {
  subnet_id                 = "${azurerm_subnet.terra-subnet-1.id}"
  network_security_group_id = "${azurerm_network_security_group.test.id}"
}