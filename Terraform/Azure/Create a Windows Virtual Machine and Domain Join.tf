# Here's what this Terraform script does:
# The provider block specifies that we're using the azurerm provider.
# The resource "azurerm_resource_group" block creates an Azure resource group named "example-rg" in the "eastus" region.
# The resource "azurerm_virtual_network" block creates an Azure virtual network named "example-vnet" in the resource group.
# The resource "azurerm_subnet" block creates a subnet named "example-subnet" within the virtual network.
# The resource "azurerm_network_interface" block creates a network interface named "example-nic" that is attached to the subnet.
# The resource "azurerm_windows_virtual_machine" block creates a Windows VM named "example-vm" that is attached to the network interface.
# The provisioner "powershell" block uses a PowerShell script to join the VM to the "example.com" domain using the Add-Computer cmdlet.
# You can run this Terraform script using the terraform init, terraform plan, and terraform apply commands.
# Just make sure to replace the resource group name, virtual network name, subnet name, and domain name with your own values. You may also need to adjust thesize and configuration of the VM depending on your needs.
# After running terraform apply, Terraform will create the specified Azure resources and domain join the Windows VM to the specified domain. You can then use the VM as you normally would in a domain-joined environment.
# Note that in the provisioner "powershell" block, we're using the Add-Computer cmdlet to join the VM to the domain. This cmdlet will prompt you for domain credentials, so make sure to enter them when prompted during the provisioning process.
# Also, be sure to properly secure any sensitive information such as passwords or credentials used in this Terraform script. You may want to consider using Terraform's variable and state file encryption features to protect this information.


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

resource "azurerm_network_interface" "example" {
  name                = "example-nic"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  ip_configuration {
    name                          = "example-ipconfig"
    subnet_id                     = azurerm_subnet.example.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_windows_virtual_machine" "example" {
  name                  = "example-vm"
  location              = azurerm_resource_group.example.location
  resource_group_name   = azurerm_resource_group.example.name
  size                  = "Standard_DS1_v2"
  admin_username        = "adminuser"
  admin_password        = "P@ssw0rd123"
  computer_name         = "example-vm"
  network_interface_ids = [azurerm_network_interface.example.id]

  os_disk {
    name              = "example-osdisk"
    caching           = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }

  provisioner "powershell" {
    inline = [
      "Add-Computer -DomainName example.com -Credential (Get-Credential) -Restart"
    ]
  }
}
