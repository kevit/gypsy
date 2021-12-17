variable "project" {
 type   = string
 default = "gypsy"
}
variable "baseImageDiskPool" {
  type    = string
  default = "default"
}
variable "domainName" {
  type    = string
  default = "gypsy.local"
}
variable "networkName" {
  type    = string
  default = "default"
}

variable "sourceImage" {
  type    = string
  default = "none"
}
