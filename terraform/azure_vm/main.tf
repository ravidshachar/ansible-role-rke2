resource "azurerm_public_ip" "ip" {
    name                = "${var.vm_name}-public-ip"
    resource_group_name = var.rg_name
    location            = var.location
    allocation_method   = "Dynamic"
}

resource "azurerm_network_interface" "nic" {
    name                = "${var.vm_name}-nic"
    resource_group_name = var.rg_name
    location            = var.location

    ip_configuration {
        name                          = "static_ip"
        subnet_id                     = var.subnet_id
        private_ip_address_allocation = "static"
        private_ip_address            = var.private_ip
        public_ip_address_id          = azurerm_public_ip.ip
    }
}

resource "azurerm_windows_virtual_machine" "vm" {
    count = var.is_windows ? 1 : 0

    name                  = var.vm_name
    resource_group_name   = var.rg_name
    location              = var.location
    network_interface_ids = [azurerm_network_interface.nic.id]
    size                  = var.size
    admin_username        = var.admin_username
    admin_password        = var.admin_password
    priority              = "Spot"
    eviction_policy       = "Deallocate"

    source_image_reference {
        publisher = var.source_image["publisher"]
        offer     = var.source_image["offer"]
        sku       = var.source_image["sku"]
        version   = var.source_image["version"]
    }

    os_disk {
        name                 = "${var.vm_name}-os-disk"
        caching              = "ReadWrite"
        storage_account_type = "Standard_LRS"
    }

    winrm_listener {
        protocol = "Http"
    }

    tags = var.tags
}

resource "azurerm_linux_virtual_machine" "vm" {
    count = var.is_windows ? 0 : 1

    name                  = var.vm_name
    resource_group_name   = var.rg_name
    location              = var.location
    network_interface_ids = [azurerm_network_interface.nic.id]
    size                  = var.size
    priority              = "Spot"
    eviction_policy       = "Deallocate"

    admin_username                  = var.admin_username
    admin_password                  = var.admin_password
    disable_password_authentication = false

    source_image_reference {
        publisher = var.source_image["publisher"]
        offer     = var.source_image["offer"]
        sku       = var.source_image["sku"]
        version   = var.source_image["version"]
    }

    os_disk {
        name                 = "${var.vm_name}-os-disk"
        caching              = "ReadWrite"
        storage_account_type = "Standard_LRS"
    }

    tags = var.tags
}