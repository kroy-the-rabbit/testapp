# User defined vars
variable "dhcp_host_port" {
    type = string
    description = "Host and port for Mikrotik updating for automatic DHCP and DNS"
}
variable "dhcp_user" {
    type = string
    description = "User for Mikrotik"
}
variable "dhcp_pass" {
    type = string
    description = "Pass for Mikrotik"
}
variable "pm_url" {
    type = string
    description = "Proxmox URL"
}
variable "pm_user" {
    type = string
    description = "Proxmox User"
}
variable "pm_pass" {
    type = string
    description = "Proxmox User"
}
