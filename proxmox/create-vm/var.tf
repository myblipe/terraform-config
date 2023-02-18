variable "ssh_key" {
  default = "ssh-key"
}
variable "proxmox_host" {
    default = "host-name"
}
variable "template_name" {
    default = "ubuntu-cloudinit-template"
}

variable "vm_count" {
  type = number
  default = 4
}
