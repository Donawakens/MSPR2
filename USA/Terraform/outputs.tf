resource "local_file" "ansible_inventory" {

  filename = "${path.module}/../Ansible/inventory/hosts.ini"

  content = templatefile("${path.module}/inventory.tftpl", {
    admin_ip        = var.admin_ip
    active_directory_ip   = var.active_directory_ip
    firewall_wan_ip    = var.firewall_wan_ip
    firewall_vlan40_ip    = var.gateway_vlan_40 # firewall_vlan 40_ip et firewall_vlan41_ip
    firewall_vlan41_ip    = var.gateway_vlan_41 # sont utilisées par ansible
  })
}