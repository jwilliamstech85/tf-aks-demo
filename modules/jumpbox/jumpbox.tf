# Windows Virtual Machine jumpbox
resource "azurerm_windows_virtual_machine" "jumpbox_vm" {
  name                = lower("${local.environment}-${var.jumpbox_suffix}")
  resource_group_name = var.jumpbox_rg_name
  location            = var.jumpbox_location
  size                = "Standard_B2s" # Cost-effective size
  admin_username      = var.jumpbox_admin_username
  admin_password      = var.jumpbox_admin_password
  network_interface_ids = [
    azurerm_network_interface.jumpbox_nic.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2022-Datacenter-Azure-Edition" # Supports multiple connections
    version   = "latest"
  }
}

# Create a Private endpoint for bastion access to the jumpbox VM
/*resource "azurerm_private_endpoint" "jumpbox_private_endpoint" {
  name                = "jumpbox-private-endpoint"
  location            = var.jumpbox_location
  resource_group_name = var.jumpbox_rg_name
  subnet_id           = var.jumpbox_subnet_id

  private_service_connection {
    name                           = "${azurerm_windows_virtual_machine.jumpbox_vm.name}-${var.pe_suffix}-connection"
    private_connection_resource_id = azurerm_windows_virtual_machine.jumpbox_vm.id
    is_manual_connection           = false
  }
}*/

# 2. Network Security Group to allow RDP
resource "azurerm_network_security_group" "jumpbox_nsg" {
  name                = "${var.jumpbox_suffix}-nsg"
  location            = var.jumpbox_location
  resource_group_name = var.jumpbox_rg_name

  security_rule {
    name                       = "AllowBastionInBound"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = var.nsg_allowed_ip_range # Restrict to your IP for security or use "VirtualNetwork" if bastion server is in the same vnet.
    destination_address_prefix = "*"
  }
}

# 3. Network Interface Card (NIC)
resource "azurerm_network_interface" "jumpbox_nic" {
  name                = "${var.jumpbox_suffix}-nic"
  location            = var.jumpbox_location
  resource_group_name = var.jumpbox_rg_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.jumpbox_subnet_id
    private_ip_address_allocation = "Dynamic"
  }
}