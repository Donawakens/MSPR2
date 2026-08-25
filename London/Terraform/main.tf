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

####################################
# VM Nextcloud - FILE-SRV-1
####################################

resource "proxmox_virtual_environment_vm" "nextcloud" {

  name      = "FILE-SRV-1"
  node_name = var.pm_node

  clone {
    vm_id = var.base_cloud_image_id
  }

  description = "Serveur de stockage et collaboration Nextcloud"

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
    vlan_id = tonumber(var.tag_vlan_11)
  }


  initialization {

    ip_config {
      ipv4 {
        address = "${var.nextcloud_ip}/${var.cidr_vlan_11}"
        gateway = var.gateway_vlan_11
      }
    }

    user_data_file_id = "local:snippets/init.yml"

  }

}


####################################
# VM Supervision - SUP-SRV-1
####################################

resource "proxmox_virtual_environment_vm" "supervision" {

  name      = "SUP-SRV-1"
  node_name = var.pm_node

  clone {
    vm_id = var.base_cloud_image_id
  }


  description = "Serveur de Supervision de l'infrastructure"


  agent {
    enabled = false
  }


  cpu {
    cores = 2
    type  = "host"
  }


  memory {
    dedicated = 2048
  }


  disk {
    datastore_id = var.pm_storage
    interface    = "scsi0"
    size         = 40
  }


  network_device {
    bridge  = "vmbr1"
    model   = "virtio"
    vlan_id = tonumber(var.tag_vlan_11)
  }


  initialization {

    ip_config {
      ipv4 {
        address = "${var.supervision_ip}/${var.cidr_vlan_11}"
        gateway = var.gateway_vlan_11
      }
    }


    user_data_file_id = "local:snippets/init.yml"
    

  }

}


####################################
# VM ADMIN ANSIBLE
####################################

resource "proxmox_virtual_environment_vm" "admin" {

  name      = "ADMIN-SRV-1"
  node_name = var.pm_node

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
    vlan_id = tonumber(var.tag_vlan_11)
  }




  initialization {

    ip_config {
      ipv4 {
        address = "${var.admin_ip}/${var.cidr_vlan_11}"
        gateway = var.gateway_vlan_11
      }
    }


    user_data_file_id = "local:snippets/init.yml"

  }
}


####################################
# VM FIREWALL
####################################

resource "proxmox_virtual_environment_vm" "firewall" {

  name      = "FW-LDN-1"
  node_name = var.pm_node

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
    bridge  = "vmbr0"
    model   = "virtio"
  }

  network_device { 
    bridge  = "vmbr1"
    model   = "virtio"
    vlan_id = tonumber(var.tag_vlan_11)
  }

  network_device { 
    bridge  = "vmbr2"
    model   = "virtio"
    vlan_id = tonumber(var.tag_vlan_10)
  }


  initialization {

    ip_config {
      ipv4 { # vmbr0
        address = "${var.firewall_wan_ip}/${var.cidr_wan_gateway}"
        gateway = var.gateway_wan_ip
      }
    }

    ip_config {  # vmbr1 (VLAN 11)
      ipv4 {
        address = "${var.gateway_vlan_11}/${var.cidr_vlan_11}"
      }
    }

    ip_config {  # vmbr2 (VLAN 10)
      ipv4 {
        address = "${var.gateway_vlan_10}/${var.cidr_vlan_10}"
      }
    }

    user_data_file_id = "local:snippets/init.yml"

  }
}


####################################
# VM Windows Server - WIN-SRV-1
####################################

resource "proxmox_virtual_environment_vm" "win_srv_1" {

  name      = "WIN-SRV-1"
  node_name = var.pm_node

  clone {
    vm_id = var.windows_template_id
  }

  description = "Serveur Windows 1"

  agent {
    enabled = true
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
    size         = 60
  }

  network_device {
    bridge  = "vmbr1"
    model   = "virtio"
    vlan_id = tonumber(var.tag_vlan_11)
  }

  initialization {
    ip_config {
      ipv4 {
        address = "${var.active_directory_ip}/${var.cidr_vlan_11}"
        gateway = var.gateway_vlan_11
      }
    }


    user_account {
      username = "ansible"
      password = "adminadmin"
    }
  }
}


####################################
# VM Windows Server - BV-SRV-1
####################################

resource "proxmox_virtual_environment_vm" "bv_srv_1" {

  name      = "BV-SRV-1"
  node_name = var.pm_node

  clone {
    vm_id = var.windows_template_id
  }

  description = "Serveur Windows 2 (BV-SRV-1)"

  agent {
    enabled = true
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
    size         = 60
  }

  network_device {
    bridge  = "vmbr1"
    model   = "virtio"
    vlan_id = tonumber(var.tag_vlan_11)
  }

  initialization {
    ip_config {
      ipv4 {
        address = "${var.bureau_virtuel_ip}/${var.cidr_vlan_11}"
        gateway = var.gateway_vlan_11
      }
    }


    user_account {
      username = "ansible"
      password = "adminadmin"
    }
  }
}