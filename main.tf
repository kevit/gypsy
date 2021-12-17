# Base OS image
resource "libvirt_volume" "baseosimage" {
  name   = "baseOSImage_${var.project}"
  source = var.sourceImage
  pool   = var.baseImageDiskPool
}
