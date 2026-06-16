variable "cidr_block_subnet-1" {
  default = "10.0.0.0/24"
}
variable "cidr_block_subnet-2" {
  default = "10.0.1.0/24"
}
variable "username" {
  default = "admin"
}
variable "password" {
  default = "sweety_3114"
  sensitive = true
}