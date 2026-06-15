resource "aws_instance" "name" {
  ami = "ami-00e801948462f718a"
  instance_type = "t3.micro"
  count = length(var.sweety)
  tags = {
   Name = "var.sweety[count.index]"
  }
}