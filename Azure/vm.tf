# Create Public IP
resource "azurerm_public_ip" "datasourceip" {
name = "testPublicIp"
location="${azurerm_resource_group.terra-res.location}"
resource_group_name = "${azurerm_resource_group.terra-res.name}"
public_ip_address_allocation="dynamic"
}

# Create network interface
resource "azurerm_network_interface" "myvm_int" {
name = "myvm_NIC"
location = "${azurerm_resource_group.terra-res.location}"
resource_group_name = "${azurerm_resource_group.terra-res.name}"
ip_configuration {
    name = "Server2016"
    subnet_id = "${azurerm_subnet.terra-subnet-1.id}"
    private_ip_address_allocation = "dynamic"
    public_ip_address_id = "${azurerm_public_ip.datasourceip.id}"
}}

# Create a Virtual Machine
resource "azurerm_virtual_machine" "test" {
    name = "myvm"
    location="${azurerm_resource_group.terra-res.location}"
    resource_group_name = "${azurerm_resource_group.terra-res.name}"
    network_interface_ids = ["${azurerm_network_interface.myvm_int.id}"]
    vm_size = "Standard_B1ms"
    delete_os_disk_on_termination = "true"
    delete_data_disks_on_termination = "true"


    storage_image_reference {
    publisher = "${var.vm_image_publisher}"
    offer = "${var.vm_image_offer}"
    sku = "${var.vm_image_sku}"
    version = "${var.vm_image_version}"
    }

    storage_os_disk {
    name = "datadisk_new_2018_01"
    caching = "ReadWrite"
    create_option = "FromImage"
    managed_disk_type="Standard_LRS"

    }
    os_profile {
    computer_name = "SERVER2016"
    admin_username = "${var.VM_ADMIN}"
    admin_password = "${var.VM_PASSWORD}"
    }

    os_profile_windows_config {
    provision_vm_agent = "true"
    enable_automatic_upgrades = "true"
    winrm {
    protocol = "http"
    certificate_url =""
}}}

#Retrieve public IP
data "azurerm_public_ip" "test" {
name = "${azurerm_public_ip.datasourceip.name}"
resource_group_name = "${azurerm_resource_group.terra-res.name}"
depends_on = ["azurerm_virtual_machine.test"]
}
output "public_ip_address" {
value = "${data.azurerm_public_ip.test.ip_address}"}