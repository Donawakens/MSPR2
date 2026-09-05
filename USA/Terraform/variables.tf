variable "pm_host_ip" {
  type    = string
  default = "172.16.158.7"
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
  default = "px-usa"
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

########### RÉSEAU VLAN 41 ###########

variable "gateway_vlan_41" {
  type    = string
  default = "192.168.41.1"
}

variable "tag_vlan_41" {
  type    = number
  default = 41
}

variable "cidr_vlan_41" {
  type    = number
  default = 24
}

########### RÉSEAU VLAN 40 ###########

variable "gateway_vlan_40" {
  type    = string
  default = "192.168.40.1"
}

variable "tag_vlan_40" {
  type    = number
  default = 40
}

variable "cidr_vlan_40" {
  type    = number
  default = 24
}


########### IP FIREWALL WAN ###########

variable "firewall_wan_ip" {
  type    = string
  default = "172.16.158.8"
}

variable "gateway_wan_ip" {
  type    = string
  default = "172.16.255.254"
}

variable "cidr_wan_gateway" {
  type    = number
  default = 16
}

# Reste des IP via les gateway



########### IP MACHINES RÉSEAU VLAN 41 ###########

variable "admin_ip" {
  type    = string
  default = "192.168.41.10"
}

variable "active_directory_ip" {
  type    = string
  default = "192.168.41.2"
}