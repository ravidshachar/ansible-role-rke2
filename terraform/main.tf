# main resource group
resource "azurerm_resource_group" "resource_group" {
  name     = "${var.prefix}-rg"
  location = var.location
}

# vnet 10.0.0.0/16 ->
resource "azurerm_virtual_network" "vnet" {
  name = "${var.prefix}-vnet"
  address_space       = [var.vnet_address_space]
  location            = azurerm_resource_group.resource_group.location
  resource_group_name = azurerm_resource_group.resource_group.name
}

# main subnet 10.0.0.0/24
resource "azurerm_subnet" "internal" {
  name                 = "${var.prefix}-subnet"
  resource_group_name  = azurerm_resource_group.resource_group.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [cidrsubnet(azurerm_virtual_network.vnet.address_space[0], 8, 0)]
}

resource "azurerm_network_security_group" "nsg" {
  name = "${var.prefix}-nsg"
  location = azurerm_resource_group.resource_group.location
  resource_group_name = azurerm_resource_group.resource_group.name

  security_rule {
    name                       = "Allow RDP"
    priority                   = "1000"
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "TCP"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Allow SSH"
    priority                   = "1001"
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "TCP"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_subnet_network_security_group_association" "dc_assoc" {
  subnet_id                 = azurerm_subnet.internal.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}

module "dc" {
  source = "./azure_vm"

  rg_name        = azurerm_resource_group.resource_group.name
  vm_name        = "${var.prefix}-dc"
  location       = var.location
  size           = var.dc_size
  subnet_id      = azurerm_subnet.internal.id
  private_ip     = cidrhost(azurerm_subnet.internal.address_prefixes[0], 10)
  admin_username = var.domain_admin_username
  admin_password = var.domain_admin_password
  is_windows     = true
}

module "win_nodes" {
  source = "./azure_vm"
  count  = var.win_nodes

  rg_name        = azurerm_resource_group.resource_group.name
  vm_name        = "${var.prefix}-win${format("%02d", count.index + 1)}"
  location       = var.location
  size           = var.win_size
  subnet_id      = azurerm_subnet.internal.id
  private_ip     = cidrhost(azurerm_subnet.internal.address_prefixes[0], 100 + count.index)
  admin_username = var.local_admin_username
  admin_password = var.local_admin_password
  is_windows     = true
}

module "master_nodes" {
  source = "./azure_vm"
  count  = var.master_nodes

  rg_name        = azurerm_resource_group.resource_group.name
  vm_name        = "${var.prefix}-cp${format("%02d", count.index + 1)}"
  location       = var.location
  size           = var.cp_size
  subnet_id      = azurerm_subnet.internal.id
  private_ip     = cidrhost(azurerm_subnet.internal.address_prefixes[0], 20 + count.index)
  admin_username = var.local_admin_username
  admin_password = var.local_admin_password
  is_windows     = false
  source_image   = {
        "publisher" = "canonical"
        "offer"     = "0001-com-ubuntu-server-focal"
        "sku"       = "20_04-lts"
        "version"   = "latest"
  }
}

module "lin_nodes" {
  source = "./azure_vm"
  count  = var.lin_nodes

  rg_name        = azurerm_resource_group.resource_group.name
  vm_name        = "${var.prefix}-lin${format("%02d", count.index + 1)}"
  location       = var.location
  size           = var.lin_size
  subnet_id      = azurerm_subnet.internal.id
  private_ip     = cidrhost(azurerm_subnet.internal.address_prefixes[0], 200 + count.index)
  admin_username = var.local_admin_username
  admin_password = var.local_admin_password
  is_windows     = false
  source_image   = {
        "publisher" = "canonical"
        "offer"     = "0001-com-ubuntu-server-focal"
        "sku"       = "20_04-lts"
        "version"   = "latest"
  }
}