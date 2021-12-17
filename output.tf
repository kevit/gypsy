output "vm" {
  value = [libvirt_domain.gypsyvm.*]
}

resource "null_resource" "update_inventory" {
    provisioner "local-exec" {
        # recreate ansible inventory
        command = "echo '${templatefile("${path.module}/inventory.tpl", { hosts = libvirt_domain.gypsyvm })}' > inventory.ini"
    }
}

output "inventory" {
    value = templatefile("${path.module}/inventory.tpl", { hosts = libvirt_domain.gypsyvm })
}
