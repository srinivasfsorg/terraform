resource "aws_instance" "ec2" {
  ami           = ami-0c509cb7181d98a35
  region        ="us-west-1"
  instance_type = "c6g.medium"
  tags = {
    Name = "ec2"
  }
}
