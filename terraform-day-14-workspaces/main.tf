resource "aws_instance" "name" {
  ami = "ami-00e801948462f718a"
  instance_type = "t3.micro"
}  

#when we use terraform workspace new dev,prod,test; it creats different statefiles,enviornment and same code