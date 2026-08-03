resource "local_file" "ansible_inventory" {

  filename = "${path.module}/../Ansible/inventory/hosts.ini"

  content = templatefile("${path.module}/inventory.tftpl", {
    admin_ip        = var.admin_ip
    nextcloud_ip    = var.nextcloud_ip
    supervision_ip  = var.supervision_ip
  })
}