resource "aws_subnet" "mysubnet" {
  vpc_id     = aws_vpc.akhil.id
  cidr_block = "10.0.0.0/24"

  tags = {
    Name = "main"
  }
}
