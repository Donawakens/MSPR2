resource "local_file" "ansible_inventory" {

  filename = "${path.module}/../Ansible/inventory/hosts.ini"

  content = templatefile("${path.module}/inventory.tftpl", {
    admin_ip        = var.admin_ip
    nextcloud_ip    = var.nextcloud_ip
    supervision_ip  = var.supervision_ip
    active_directory_ip   = var.active_directory_ip
    bureau_virtuel_ip    = var.bureau_virtuel_ip
    firewall_wan_ip    = var.firewall_wan_ip
    firewall_vlan10_ip    = var.gateway_vlan_10 # firewall_vlan 10_ip et firewall_vlan11_ip
    firewall_vlan11_ip    = var.gateway_vlan_11 # sont utilisées par ansible
  })
}