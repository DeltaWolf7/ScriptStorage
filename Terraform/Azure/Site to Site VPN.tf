# This Terraform script does the following:
# The provider block specifies that we're using the azurerm provider.
# The resource "azurerm_resource_group" block creates an Azure resource group named "example-rg" in the "eastus" region.
# The resource "azurerm_virtual_network" block creates an Azure virtual network named "example-vnet" with an address space of 10.0.0.0/16 in the same resource group and region as the resource group created in step 2.
# The resource "azurerm_subnet" block creates a subnet named "example-subnet" with an address prefix of 10.0.1.0/24 in the virtual network created in step 3.
# The resource "azurerm_virtual_network_gateway" block creates an Azure virtual network gateway named "example-vpn-gateway" with a public IP address and a connection to the subnet created in step 4.
# The resource "azurerm_local_network_gateway" block creates a local network gateway named "example-local-gateway" with the IP address of the on-premises VPN device and the IP address range of the on-premises network.
# The resource "azurerm_public_ip" block creates a public IP address for the virtual network gateway created in step 5.
# The resource "azurerm_virtual_network_gateway_connection" block creates a site-to-site VPN connection between the virtual network gateway created in step 5 and the local network gateway created in step 6. The connection uses IPsec with a shared key and the specified encryption and integrity settings.
# After running terraform apply, Terraform will create the specified Azure resources and configure the site-to-site VPN connection. You can then configure your on-premises VPN device to connect to the virtual network gateway created by Terraform.
# Note that this Terraform script assumes that you already have an on-premises VPN device set up and configured. You will need to modify the script to match the settings of your on-premises VPN device, such as the IP address and encryption settings.


provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "example" {
  name     = "example-rg"
  location = "eastus"
}

resource "azurerm_virtual_network" "example" {
  name                = "example-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
}

resource "azurerm_subnet" "example" {
  name                 = "example-subnet"
  address_prefixes     = ["10.0.1.0/24"]
  virtual_network_name = azurerm_virtual_network.example.name
  resource_group_name  = azurerm_resource_group.example.name
}

resource "azurerm_virtual_network_gateway" "example" {
  name                = "example-vpn-gateway"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  type                = "Vpn"
  vpn_type            = "RouteBased"
  sku                 = "VpnGw1"
  active_active       = false

  ip_configuration {
    name                           = "example-gateway-ipconfig"
    subnet_id                      = azurerm_subnet.example.id
    public_ip_address_id           = azurerm_public_ip.example.id
    private_ip_allocation_method   = "Dynamic"
  }
}

resource "azurerm_local_network_gateway" "example" {
  name                = "example-local-gateway"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  gateway_ip_address  = "203.0.113.10"
  address_space       = ["192.168.1.0/24"]
}

resource "azurerm_public_ip" "example" {
  name                = "example-vpn-gateway-ip"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  allocation_method   = "Dynamic"
}

resource "azurerm_virtual_network_gateway_connection" "example" {
  name                            = "example-vpn-connection"
  location                        = azurerm_resource_group.example.location
  resource_group_name             = azurerm_resource_group.example.name
  virtual_network_gateway_id      = azurerm_virtual_network_gateway.example.id
  local_network_gateway_id        = azurerm_local_network_gateway.example.id
  connection_type                 = "IPsec"
  shared_key                      = "MySharedKey"
  routing_weight                  = 10
  enable_bgp                      = false

  ipsec_policy {
    sa_life_time_seconds          = 27000
    sa_data_size_kilobytes        = 1024000000
    ipsec_encryption              = "AES256"
    ipsec_integrity               = "SHA1"
    ike_encryption                = "AES256"
    ike_integrity                 = "SHA384"
    dh_group                      = "DHGroup14"
    pfs_group                     = "PFS2"
  }
}
