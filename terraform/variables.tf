variable "prefix" {
    type        = string
    default     = "rke2-lab"
    description = "prefix for azure resources including RG"
    validation {
        condition     = length(var.prefix) < 11
        error_message = "Prefix must be smaller than 11"
    }
}

variable "location" {
    type        = string
    default     = "West Europe"
    description = "location for all resources"
}

variable "vnet_address_space" {
    type        = string
    default     = "10.0.0.0/16"
    description = "main vnet address space"
}

variable "dc_size" {
    type    = string
    default = "Standard_A2_v2"
}

variable "win_size" {
    type        = string
    default     = "Standard_A4_v2"
    description = "VM size for windows workers"
}

variable "cp_size" {
    type    = string
    default = "Standard_A2_v2"
    description = "VM size for control plane nodes"
}

variable "lin_size" {
    type    = string
    default = "Standard_A2_v2"
    description = "VM size for linux workers"
}

variable "win_nodes" {
    type        = number
    default     = 1
    description = "number of windows workers"
}

variable "master_nodes" {
    type        = number
    default     = 1
    description = "number of master nodes, should be odd"
}

variable "lin_nodes" {
    type        = number
    default     = 1
    description = "number of linux workers"
}

variable "domain_admin_username" {
    type    = string
    default = "domainadmin"
}

variable "domain_admin_password" {
    type      = string
    sensitive = true
}

variable "local_admin_username" {
    type    = string
    default = "localadmin"
}

variable "local_admin_password" {
    type      = string
    sensitive = true
}