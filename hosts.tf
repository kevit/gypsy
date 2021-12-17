variable "hosts" {
  default = {
    "voyager1" = {
       name = "voyager1",
       vcpu     = 1,
       memory   = "1024",
       diskpool = "default",
       disksize = "4000000000",
       mac      = "52:54:00:00:00:01",
     },
  }
}

resource "libvirt_volume" "qcow2_volume" {
  for_each = var.hosts
  name           = "${each.value.name}.qcow2"
  base_volume_id = libvirt_volume.baseosimage.id
  pool           = each.value.diskpool
  format         = "qcow2"
  size           = each.value.disksize
}

data "template_file" "user_data" {
  template = file("${path.module}/cloud_init.cfg")
  for_each   = var.hosts
  vars     = {
    hostname   = each.value.name
    domainname = var.domainName
  }
}

resource "libvirt_cloudinit_disk" "initdisk" {
  for_each   = var.hosts
  name      = "initdisk_${each.value.name}.iso"
  user_data = data.template_file.user_data[each.key].rendered
}

resource "libvirt_domain" "gypsyvm" {
  for_each   = var.hosts
  name   = each.value.name
  memory = each.value.memory
  vcpu   = each.value.vcpu

  network_interface {
    network_name   = var.networkName
    mac            = each.value.mac
    wait_for_lease = var.networkName == "host-bridge" ? false : true
  }

  disk {
    volume_id = element(libvirt_volume.qcow2_volume[each.key].*.id, 1 )
  }

  cloudinit = libvirt_cloudinit_disk.initdisk[each.key].id

}
