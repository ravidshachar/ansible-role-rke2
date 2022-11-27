variable "rg_name" {
    type        = string
    description = "resource group name"
}

variable "vm_name" {
    type        = string
    description = "name for VM"
}

variable "location" {
    type        = string
    default     = "West Europe"
    description = "location for vm"
}

variable "size" {
    type        = string
    default     = "Standard_A4_v2"
    description = "Size for VM"
}

variable "subnet_id" {
    type        = string
    description = "Subnet id for VM"
}

variable "private_ip" {
    type        = string
    description = "private ip address"
}

variable "admin_username" {
    type        = string
    default     = "localadmin"
    description = "local admin username"
}

variable "admin_password" {
    type        = string
    sensitive   = true
    description = "local admin password"
    validation {
        condition     = length(var.admin_password) >= 12 && length(var.admin_password) <= 72
        error_message = "Password length must be between 12 and 72."
    }
}

variable "source_image" {
    type = map(string)
    default = {
        "publisher" = "MicrosoftWindowsServer"
        "offer"     = "WindowsServer"
        "sku"       = "2022-Datacenter"
        "version"   = "latest"
    }
    description = "source OS image details"
}

variable "tags" {
    type = map(string)
    default = {}
    description = "optional tags for vm"
}

variable "is_windows" {
    type = bool
    description = "True for windows, False for linux"
}