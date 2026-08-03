variable "pm_host_ip" {
  type    = string
  default = "172.16.158.2"
}

variable "pm_token_id" {
  type    = string
  default = "terraform@pam!tf"
}

variable "pm_token_secret" {
  type      = string
  sensitive = true
}

variable "pm_node" {
  type    = string
  default = "px-london"
}

variable "pm_storage" {
  type    = string
  default = "local-lvm"
}

variable "base_cloud_image_id" {
  type        = number
  description = "ID du template Cloud-Init Proxmox"
  default     = 9000
}


########### RÉSEAU VLAN 21 ###########

variable "gateway_vlan_21" {
  type    = string
  default = "192.168.21.1"
}

variable "vlan_tag" {
  type    = number
  default = 21
}

variable "cidr_vlan_21" {
  type    = number
  default = 24
}

variable "nextcloud_replicas_ip" {
  type    = string
  default = "192.168.21.4"
}

variable "admin_ip" {
  type    = string
  default = "192.168.21.10"
}