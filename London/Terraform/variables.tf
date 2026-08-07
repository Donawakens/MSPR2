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

variable "windows_template_id" {
  type        = number
  description = "ID du template Windows"
  default     = 9500 
}

########### RÉSEAU VLAN 11 ###########

variable "gateway_vlan_11" {
  type    = string
  default = "192.168.11.1"
}

variable "vlan_tag" {
  type    = number
  default = 11
}

variable "cidr_vlan_11" {
  type    = number
  default = 24
}

########### IP MACHINES RÉSEAU VLAN 11 ###########


variable "nextcloud_ip" {
  type    = string
  default = "192.168.11.3"
}

variable "supervision_ip" {
  type    = string
  default = "192.168.11.4"
}

variable "admin_ip" {
  type    = string
  default = "192.168.11.10"
}

variable "active_directory_ip" {
  type    = string
  default = "192.168.11.2"
}

variable "bureau_virtuel_ip" {
  type    = string
  default = "192.168.11.5"
}