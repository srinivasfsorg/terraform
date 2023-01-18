resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.akhil.id

  tags = {
    Name = "akhil"
  }
}
