resource "azurerm_lb" "lb" {
  name                = "${var.prefix}-lb"
  location            = azurerm_resource_group.resource_group.location
  resource_group_name = azurerm_resource_group.resource_group.name
  sku                 = "Standard"

  frontend_ip_configuration {
    name                          = "frontend"
    subnet_id                     = azurerm_subnet.internal.id
    private_ip_address            = var.lb_ip
    private_ip_address_allocation = "Static"
  }
}

resource "azurerm_lb_backend_address_pool" "be_pool" {
  loadbalancer_id = azurerm_lb.lb.id
  name            = "backend"
}

resource "azurerm_lb_backend_address_pool_address" "be_pool_ips" {
  count = var.master_nodes
  
  name                    = "be-ip${count.index}"
  backend_address_pool_id = azurerm_lb_backend_address_pool.be_pool.id
  virtual_network_id      = azurerm_virtual_network.vnet.id
  ip_address              = module.master_nodes[count.index].private_ip
}

#resource "azurerm_network_interface_backend_address_pool_association" "be_assoc" {
#  count                   = var.master_nodes
#
#  network_interface_id    = module.master_nodes[count.index].nic_id
#  ip_configuration_name   = module.master_nodes[count.index].ip_config_name
#  backend_address_pool_id = azurerm_lb_backend_address_pool.be_pool.id
#
#}

resource "azurerm_lb_rule" "kube_api" {
  loadbalancer_id                = azurerm_lb.lb.id
  name                           = "kube-api"
  protocol                       = "Tcp"
  frontend_port                  = 6443
  backend_port                   = 6443
  frontend_ip_configuration_name = "frontend"
  probe_id                       = azurerm_lb_probe.kube_api_probe.id
  backend_address_pool_ids        = ["${azurerm_lb_backend_address_pool.be_pool.id}"]
}

resource "azurerm_lb_rule" "node_registration" {
  loadbalancer_id                = azurerm_lb.lb.id
  name                           = "node-registration"
  protocol                       = "Tcp"
  frontend_port                  = 9345
  backend_port                   = 9345
  frontend_ip_configuration_name = "frontend"
  probe_id                       = azurerm_lb_probe.kube_api_probe.id
  backend_address_pool_ids        = ["${azurerm_lb_backend_address_pool.be_pool.id}"]
}

resource "azurerm_lb_probe" "kube_api_probe" {
  loadbalancer_id     = azurerm_lb.lb.id
  name                = "kube-api-probe"
  port                = 6443
}