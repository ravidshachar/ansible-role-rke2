output "nic_id" {
    value = azurerm_network_interface.nic.id
}

output "ip_config_name" {
    value = azurerm_network_interface.nic.ip_configuration.0.name
}

output "private_ip" {
    value = var.private_ip
}