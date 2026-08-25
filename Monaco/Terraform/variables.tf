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

variable "tag_vlan_21" {
  type    = number
  default = 21
}

variable "cidr_vlan_21" {
  type    = number
  default = 24
}


########### RÉSEAU VLAN 20 ###########

variable "gateway_vlan_20" {
  type    = string
  default = "192.168.20.1"
}

variable "tag_vlan_20" {
  type    = number
  default = 20
}

variable "cidr_vlan_20" {
  type    = number
  default = 24
}


########### IP FIREWALL WAN ###########

variable "firewall_wan_ip" {
  type    = string
  default = "172.16.158.5"
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


########### IP MACHINES RÉSEAU VLAN 11 ###########

variable "nextcloud_replicas_ip" {
  type    = string
  default = "192.168.21.4"
}

variable "admin_ip" {
  type    = string
  default = "192.168.21.10"
}