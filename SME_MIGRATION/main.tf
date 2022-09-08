resource "azurerm_resource_group" "beaconsmes_gp" {
  name     = "BeaconSme_projects"
  location = "uksouth"
 

  tags = {
    Owner = "Lukman Adebayo"
    purpose = "Beacon Sme Migration to the cloud"
  }
}

variable "prefix" {
  default = "SMEs"
}

resource "azurerm_virtual_network" "main" {
  name                = "${var.prefix}-network"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.beaconsmes_gp.location
  resource_group_name = azurerm_resource_group.beaconsmes_gp.name
}

resource "azurerm_subnet" "internal" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.beaconsmes_gp.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_network_interface" "main" {
  name                = "${var.prefix}-nic"
  location            = azurerm_resource_group.beaconsmes_gp.location
  resource_group_name = azurerm_resource_group.beaconsmes_gp.name

  ip_configuration {
    name                          = "beaconipconfig"
    subnet_id                     = azurerm_subnet.internal.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.beaconpubid.id
  }
}


resource "azurerm_network_interface_security_group_association" "networkung" {
  network_interface_id      = azurerm_network_interface.main.id
  network_security_group_id = azurerm_network_security_group.becsme.id
}

resource "azurerm_subnet_network_security_group_association" "smesub" {
  subnet_id                 = azurerm_subnet.internal.id
  network_security_group_id = azurerm_network_security_group.becsme.id
}


resource "azurerm_network_security_group" "becsme" {
  name                = "beaconnsg"
  location            = azurerm_resource_group.beaconsmes_gp.location
  resource_group_name = azurerm_resource_group.beaconsmes_gp.name

  security_rule {
    name                       = "smensg"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix    = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "allow_http"
    priority                   = 200
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix    = "*"
    destination_address_prefix = "*"
  }

  tags = {
    environment = "VMnsg"
  }
}


resource "azurerm_public_ip" "beaconpubid" {
  name                = "beaconpubid"
  resource_group_name = azurerm_resource_group.beaconsmes_gp.name
  location            = azurerm_resource_group.beaconsmes_gp.location
  allocation_method   = "Dynamic"
  sku = "Basic"

  tags = {
    environment = "Production"
  }
}

resource "azurerm_virtual_machine" "main" {
  name                  = "${var.prefix}-vm"
  location              = azurerm_resource_group.beaconsmes_gp.location
  resource_group_name   = azurerm_resource_group.beaconsmes_gp.name
  network_interface_ids = [azurerm_network_interface.main.id]
  vm_size               = "Standard_DS3_v2"

  # Uncomment this line to delete the OS disk automatically when deleting the VM
   delete_os_disk_on_termination = true

  # Uncomment this line to delete the data disks automatically when deleting the VM
  delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }
  storage_os_disk {
    name              = "myosdisk1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = "hostname"
    admin_username = "beaconinc"
    admin_password = "Gent22@senfreth?"
  }
  os_profile_windows_config { 
    provision_vm_agent = true
}
  tags = {
    owner = "Lukman"
  }
}