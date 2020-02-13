    # Create a resource group
    resource "azurerm_resource_group" "terra-res" {
    name = "PROD-RG"
    location = "uk south"
    }