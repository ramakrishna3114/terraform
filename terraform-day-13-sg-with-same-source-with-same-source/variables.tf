variable "cidr_block" {
  default = "10.0.0.0/24"
}
variable "ami" {
  default = "ami-00e801948462f718a"
}
variable "instance_type" {
  default = "t3.micro"
}
variable "sgrule" {
    type = list(string)
    default = ["22","80","443"]
  
}