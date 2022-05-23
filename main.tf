# Change $PROXMOXSERVERIP to one of your Proxmox Node's IPs or FQDN.
# Change $SUPERSECRETPASSWORD to the root password of the node.

terraform {
  required_providers {
    proxmox = {
      source = "Telmate/proxmox"
      version = "2.9.10"
    }
  }
}


provider "proxmox" {
    pm_api_url = "https://${PROXMOX_URL}:8006/api2/json"
    pm_user = "root@pam"
    pm_password = "${PROXMOXSUPERSECRETPASSWORD}"
    pm_tls_insecure = "true"
}

# Change $NODETOBEDEPLOYED to the node where you want the VMs to be created at.
resource "proxmox_vm_qemu" "proxmox_vm" {
  count             = 1
  name              = "tf-vm-${count.index}"
  target_node       = "${NODETOBEDEPLOYED}"
  clone             = "debian-10"
  os_type           = "cloud-init"
  cores             = 1
  sockets           = "1"
  cpu               = "host"
  memory            = 2048
  scsihw            = "virtio-scsi-pci"
  bootdisk          = "scsi0"
  agent             = 0
disk {
    size            = "35G"
    type            = "scsi"
    storage         = "local"
    iothread        = 0
  }
network {
    model           = "virtio"
    bridge          = "vmbr0"
  }
lifecycle {
    ignore_changes  = [
      network,
    ]
  }
# Cloud Init Settings (Change the IP range and the GW to suit your needs)
  ipconfig0 = "ip=10.10.10.15${count.index + 1}/24,gw=10.10.10.1"
sshkeys = <<EOF
${SSHPERSONALPUBLICKEY}  
EOF
}
