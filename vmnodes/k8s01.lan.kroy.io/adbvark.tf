terraform {
  required_version = ">= 0.14"
  required_providers {
    proxmox = {
      source = "telmate/proxmox"
    }
    mikrotik = {
        source = "ddelnano/mikrotik"
        version = "0.3.6"
    }
    rk = {
        source = "rancher/rke"
    }
  }
}

provider "mikrotik" {
    host = var.dhcp_host_port
    username = var.dhcp_user
    password = var.dhcp_pass
}

provider "proxmox" {
    pm_api_url = var.pm_url
    pm_user = var.pm_user
    pm_password = var.pm_pass
    pm_tls_insecure = false 
    pm_debug = true
}
