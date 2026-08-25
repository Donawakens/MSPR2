resource "local_file" "ansible_inventory" {

  filename = "${path.module}/../Ansible/inventory/hosts.ini"

  content = templatefile("${path.module}/inventory.tftpl", {
    admin_ip        = var.admin_ip
    nextcloud_replicas_ip    = var.nextcloud_replicas_ip
    firewall_wan_ip    = var.firewall_wan_ip
    firewall_vlan20_ip    = var.gateway_vlan_20 # firewall_vlan 20_ip et firewall_vlan21_ip
    firewall_vlan21_ip    = var.gateway_vlan_21 # sont utilisées par ansible
  })
}