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
# VM ADMIN ANSIBLE
####################################

resource "proxmox_virtual_environment_vm" "admin" {

  name      = "ADMIN-SRV-3"
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
    vlan_id = tonumber(var.tag_vlan_41)
  }

  network_device { # Acces admin
    bridge  = "vmbr0"
    model   = "virtio"
  }



  initialization {

    ip_config {
      ipv4 {
        address = "${var.admin_ip}/${var.cidr_vlan_41}"
        gateway = var.gateway_vlan_41
      }
    }

    ip_config { # Nécessaire pour l'install de git, l'accès au repo git, etc.
      ipv4 {
        address = "172.16.158.12/16"
        gateway = "172.16.255.254"
      }
    }



    user_data_file_id = "local:snippets/init.yml"

  }
}


####################################
# VM FIREWALL
####################################

resource "proxmox_virtual_environment_vm" "firewall" {

  name      = "FW-USA-1"
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
    vlan_id = tonumber(var.tag_vlan_41)
  }

  network_device { 
    bridge  = "vmbr2"
    model   = "virtio"
    vlan_id = tonumber(var.tag_vlan_40)
  }


  initialization {

    ip_config {
      ipv4 { # vmbr0
        address = "${var.firewall_wan_ip}/${var.cidr_wan_gateway}"
        gateway = var.gateway_wan_ip
      }
    }

    ip_config {  # vmbr1 (VLAN 41)
      ipv4 {
        address = "${var.gateway_vlan_41}/${var.cidr_vlan_41}"
      }
    }

    ip_config {  # vmbr2 (VLAN 40)
      ipv4 {
        address = "${var.gateway_vlan_40}/${var.cidr_vlan_40}"
      }
    }

    user_data_file_id = "local:snippets/init.yml"

  }
}



####################################
# VM Windows Server - WIN-SRV-2
####################################

resource "proxmox_virtual_environment_vm" "win_srv_2" {

  name      = "WIN-SRV-2"
  node_name = var.pm_node

  clone {
    vm_id = var.windows_template_id
  }

  description = "Serveur Windows 2"

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
    vlan_id = tonumber(var.tag_vlan_41)
  }

  initialization {
    ip_config {
      ipv4 {
        address = "${var.active_directory_ip}/${var.cidr_vlan_41}"
        gateway = var.gateway_vlan_41
      }
    }


    user_account {
      username = "ansible"
      password = "adminadmin"
    }
  }
}
