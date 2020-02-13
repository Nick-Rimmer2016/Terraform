/* Declare variables*/
provider "azurerm" {
  subscription_id 	= "${var.subscription_id}"
  client_id 		    = "${var.client_id}"
  client_secret 	  = "${var.client_secret}"
  tenant_id 		    = "${var.tenant_id}"
}
variable "subscription_id" {
  description = "Subscription ID"
  default = "xxxxxx"
}
variable "client_id" {
  description = "Web App Id"
  default = "xxxxxx"
}
variable "client_secret" {
  description = "Key for Service principal"
  default = "xxxxxx"
}
variable "tenant_id" {
  description = ""
  default = "xxxxxx"
}
variable "vm_size" {
// Get-AzureRmVMSize -Location 'uksouth' | select name, NumberOfCores, MemoryInMB, ResourceDiskSizeInMB | ft
description = "VM instance size"
default = "Standard_B1ms"
}
variable "vm_image_publisher" {
// Get-AzureRmVMImagePublisher -Location 'uksouth' | Select PublisherName
description = "vm image vendor"
default = "MicrosoftWindowsServer"
}
variable "vm_image_offer" {
//Get-AzureRMVMImageOffer -Location 'uksouth' -Publisher 'MicrosoftWindowsServer' | Select Offer
description = "vm image vendor's VM offering"
default = "WindowsServer"
}
variable "vm_image_sku" {
default = "2016-Datacenter"
}
variable "vm_image_version" {
description = "vm image version"
default = "latest"
}
variable "VM_ADMIN" {
description = "Admin Name"
default = "techsnipadmin"
}
variable "VM_PASSWORD" {
description = "password"
default = "add password here"
}