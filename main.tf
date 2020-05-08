provider "proxmox" {
    pm_api_url = "https://$PROXMOXSERVERIP:8006/api2/json"
    pm_user = "root@pam"
    pm_password = "$SUPERSECRETPASSWORD"
    pm_tls_insecure = "true"
}

resource "proxmox_vm_qemu" "proxmox_vm" {
  count             = 1
  name              = "tf-vm-${count.index}"
  target_node       = "$NODETOBEDEPLOYED"
clone             = "debian-cloudinit"
os_type           = "cloud-init"
  cores             = 4
  sockets           = "1"
  cpu               = "host"
  memory            = 2048
  scsihw            = "virtio-scsi-pci"
  bootdisk          = "scsi0"
disk {
    id              = 0
    size            = 20
    type            = "scsi"
    storage         = "data2"
    storage_type    = "lvm"
    iothread        = true
  }
network {
    id              = 0
    model           = "virtio"
    bridge          = "vmbr0"
  }
lifecycle {
    ignore_changes  = [
      network,
    ]
  }
# Cloud Init Settings
  ipconfig0 = "ip=10.10.10.15${count.index + 1}/24,gw=10.10.10.1"
sshkeys = <<EOF
  ${var.ssh_key}
  EOF
}
