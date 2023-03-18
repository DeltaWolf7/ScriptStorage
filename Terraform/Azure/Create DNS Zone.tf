# This Terraform script creates an Azure resource group and a DNS zone within that resource group. Here's a breakdown of what each section of the script does:
# The provider block specifies that we're using the azurerm provider.
# The resource "azurerm_resource_group" block creates an Azure resource group named "example-rg" in the "eastus" region.
# The resource "azurerm_dns_zone" block creates an Azure DNS zone named "example.com" in the resource group created in the previous step.
# The resource_group_name argument in the azurerm_dns_zone resource specifies the name of the resource group that the DNS zone should be created in.
# The tags argument in the azurerm_dns_zone resource specifies a set of key-value pairs that can be used to tag the DNS zone for organizational purposes.
# You can run this Terraform script using the terraform init, terraform plan, and terraform apply commands. Just make sure to replace the resource group name and DNS zone name with your own values.


provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "example" {
  name     = "example-rg"
  location = "eastus"
}

resource "azurerm_dns_zone" "example" {
  name                = "example.com"
  resource_group_name = azurerm_resource_group.example.name

  tags = {
    environment = "production"
  }
}
