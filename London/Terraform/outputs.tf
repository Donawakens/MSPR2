resource "local_file" "ansible_inventory" {

  filename = "${path.module}/../Ansible/inventory/hosts.ini"

  content = templatefile("${path.module}/inventory.tftpl", {
    admin_ip        = var.admin_ip
    syncin_ip    = var.syncin_ip
    syncin_datacenter_ip    = var.syncin_datacenter_ip 
    supervision_ip  = var.supervision_ip
    active_directory_ip   = var.active_directory_ip
    bureau_virtuel_ip    = var.bureau_virtuel_ip

    firewall_wan_ip    = var.firewall_wan_ip
    firewall_vlan10_ip    = var.gateway_vlan_10 # utilisé par ansible
    firewall_vlan11_ip    = var.gateway_vlan_11 # utilisé par ansible

    firewall_datacenter_wan_ip    = var.firewall_datacenter_wan_ip
    firewall_vlan50_ip    = var.gateway_vlan_50 # utilisé par ansible

    firewall_australie_wan_ip    = var.firewall_australie_wan_ip
    firewall_vlan30_ip    = var.gateway_vlan_30 # utilisé par ansible
  })
}