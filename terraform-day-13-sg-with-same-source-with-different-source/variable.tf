variable "cidr_block" {
  default = "10.0.0.0/24"
}
variable "ami" {
  default = "ami-00e801948462f718a"
}
variable "sgrule" {
  type = map(string)
  default = {
    "22" = "10.0.0.0/24"
    "80" = "0.0.0.0/0"
    "443" = "0.0.0.0/0"
  }
}