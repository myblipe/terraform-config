terraform {
 required_providers {
  proxmox = {
   source = "telmate/proxmox"
   version = "2.9.11"
   }
 }
}

provider "proxmox" {
  pm_api_url = "https://URI:8006/api2/json"
  pm_api_token_id = "token-id-api"
  pm_api_token_secret = "token-secret-api"
  pm_tls_insecure = true
}

resource "proxmox_vm_qemu" "cloudinit" {
for_each = { for i in range(var.vm_count) : "vm-${i+1}" => i }
 name = each.key
 desc = "tf description of ${each.value+1}"
 target_node = var.proxmox_host
 
 clone = var.template_name
 agent = 1
 os_type = "cloud-init"
 cores = 2
 sockets = 1
 cpu = "host"
 memory = 2048
 scsihw = "virtio-scsi-pci"
 bootdisk = "scsi0"
 disk {
  slot = 0
  size = "10G"
  type = "scsi"
  storage = "local"
  iothread = 1
 }
 network {
  model = "virtio"
  bridge = "vmbr1"
  }
 lifecycle {
  ignore_changes = [
   network,
   ]
  }
 ipconfig0 = "ip=10.0.10.1${each.value+1}/24,gw=10.0.10.1"

 sshkeys = <<EOF
 ${var.ssh_key}
 EOF
}
