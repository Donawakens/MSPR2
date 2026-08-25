terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "~> 0.70"
    }
  }
}

provider "proxmox" {
  endpoint = "https://${var.pm_host_ip}:8006/"

  api_token = "${var.pm_token_id}=${var.pm_token_secret}"

  insecure = true
}

########################################
# VM Nextcloud Réplicas - FILE-SRV-1
########################################

resource "proxmox_virtual_environment_vm" "nextcloud" {

  name      = "FILE-SRV-2"
  node_name = var.pm_node

  clone {
    vm_id = var.base_cloud_image_id
  }

  description = "Serveur de stockage et collaboration Nextcloud - Réplicas"

  agent {
    enabled = false
  }

  cpu {
    cores = 2
    type  = "host"
  }

  memory {
    dedicated = 4096
  }


  disk {
    datastore_id = var.pm_storage
    interface    = "scsi0"
    size         = 40
  }


  network_device {
    bridge  = "vmbr1"
    model   = "virtio"
    vlan_id = tonumber(var.tag_vlan_21)
  }


  initialization {

    ip_config {
      ipv4 {
        address = "${var.nextcloud_replicas_ip}/${var.cidr_vlan_21}"
        gateway = var.gateway_vlan_21
      }
    }

    user_data_file_id = "local:snippets/init.yml"

  }

}



####################################
# VM ADMIN ANSIBLE
####################################

resource "proxmox_virtual_environment_vm" "admin" {

  name      = "ADMIN-SRV-2"
  node_name = var.pm_node

  agent {
    enabled = false
  }

  clone {
    vm_id = var.base_cloud_image_id
  }

  cpu {
    cores = 2
  }

  memory {
    dedicated = 2048
  }

  disk {
    datastore_id = var.pm_storage
    interface    = "scsi0"
    size         = 20
  }


  network_device {
    bridge  = "vmbr1"
    model   = "virtio"
    vlan_id = tonumber(var.tag_vlan_21)
  }


  initialization {

    ip_config {
      ipv4 {
        address = "${var.admin_ip}/${var.cidr_vlan_21}"
        gateway = var.gateway_vlan_21
      }
    }


    user_data_file_id = "local:snippets/init.yml"

  }
}

####################################
# VM FIREWALL
####################################

resource "proxmox_virtual_environment_vm" "firewall" {

  name      = "FW-MCO-1"
  node_name = var.pm_node

  clone {
    vm_id = var.base_cloud_image_id
  }
  
  agent {
    enabled = false
  }

  cpu {
    cores = 2
  }

  memory {
    dedicated = 2048
  }

  disk {
    datastore_id = var.pm_storage
    interface    = "scsi0"
    size         = 20
  }

  network_device {
    bridge  = "vmbr0"
    model   = "virtio"
  }

  network_device { 
    bridge  = "vmbr1"
    model   = "virtio"
    vlan_id = tonumber(var.tag_vlan_21)
  }

  network_device { 
    bridge  = "vmbr2"
    model   = "virtio"
    vlan_id = tonumber(var.tag_vlan_20)
  }


  initialization {

    ip_config {
      ipv4 { # vmbr0
        address = "${var.firewall_wan_ip}/${var.cidr_wan_gateway}"
        gateway = var.gateway_wan_ip
      }
    }

    ip_config {  # vmbr1 (VLAN 21)
      ipv4 {
        address = "${var.gateway_vlan_21}/${var.cidr_vlan_21}"
      }
    }

    ip_config {  # vmbr2 (VLAN 20)
      ipv4 {
        address = "${var.gateway_vlan_20}/${var.cidr_vlan_20}"
      }
    }

    user_data_file_id = "local:snippets/init.yml"

  }
}