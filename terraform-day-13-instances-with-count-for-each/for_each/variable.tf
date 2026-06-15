variable "ami" {
  default = "ami-00e801948462f718a"
}
variable "instance_type" {
  default = "t3.micro"
}
variable "test" {
  type = list(string)
  default = [ "bread","jam","juice" ]
}