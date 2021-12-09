# Source the Cloud Init Config file
data "template_file" "cloud_init" {
  template  = "${file("${path.module}/cloud_init.cfg")}"

  vars = {
      hostname = var.hostname
      domain = var.domain
      fqdn = "${var.hostname}.${var.domain}"
  }
}
# Source the Cloud Init Config file
data "template_file" "cloud_init_netcfg" {
  template  = "${file("${path.module}/network_config.cfg")}"
}

# Create a local copy of the file, to transfer to Proxmox
resource "local_file" "cloud_init" {
  content   = data.template_file.cloud_init.rendered
  filename  = "${path.module}/files/user_data_cloud_init.cfg"
}

# Create a local copy of the file, to transfer to Proxmox
resource "local_file" "cloud_init_netcfg" {
  content   = data.template_file.cloud_init_netcfg.rendered
  filename  = "${path.module}/files/netcfg_data_cloud_init.cfg"
}

# Transfer the file to the Proxmox Host
resource "null_resource" "cloud_init" {
  connection {
    type    = "ssh"
    user    = "root"
    private_key = file("~/.ssh/id_ed25519")
    host    = "${var.node}.${var.domain}"
  }

  provisioner "file" {
    source       = local_file.cloud_init.filename
    destination  = "/mnt/pve/microntank/snippets/cloud_init.cfg"
  }

}

# Transfer the file to the Proxmox Host
resource "null_resource" "cloud_init_netcfg" {
  connection {
    type    = "ssh"
    user    = "root"
    private_key = file("~/.ssh/id_ed25519")
    host    = "${var.node}.${var.domain}"
  }

  provisioner "file" {
    source       = local_file.cloud_init_netcfg.filename
    destination  = "/mnt/pve/microntank/snippets/network_config.cfg"
  }
}

# Create the VM
resource "proxmox_vm_qemu" "vm" {
  ## Wait for the cloud-config file to exist

  depends_on = [
    null_resource.cloud_init,
    null_resource.cloud_init_netcfg
  ]

  agent = 1
  vcpus = var.cpus
  cores = var.cpus
  name = "${var.hostname}.${var.domain}"
  target_node = var.node

  full_clone = true
  clone = "ubuntu-focal-ci"
  os_type = "cloud-init"
  pool = "Kroy-Pool"

  # Cloud init options
  cicustom = "user=microntank:snippets/cloud_init.cfg,network=microntank:snippets/network_config.cfg"

  memory       = var.memory
  # Set the boot disk paramters
  #scsihw       = "virtio-scsi-pci"


  disk {
    size            = var.disk_size
    storage         = var.datastore
    type            = "virtio"
  }

  # Set the network
  network {
    model = "virtio"
    bridge = "vmbr0"
    tag = var.vlan 
  }
}
#  provisioner "local-exec" {
#    environment = {
#        IP = proxmox_vm_qemu.vm.default_ipv4_address
#    }
# }

resource "mikrotik_dhcp_lease" "dhcp" {
  depends_on = [
    proxmox_vm_qemu.vm
  ]
  address = proxmox_vm_qemu.vm.default_ipv4_address
  macaddress = proxmox_vm_qemu.vm.network[0].macaddr
  comment = "${var.hostname}.${var.domain}"
}
