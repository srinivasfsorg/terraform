################ Authentication ##########33
provider "aws" {
    region = "us-east-1"
}

#########  Networking ##############
# Step 1
resource "aws_vpc" "myvpc" {
    cidr_block = "10.0.0.0/16"
    tags = {
      "Name" = "myvpc"
    }

}

# Step 2
resource "aws_internet_gateway" "myigw" {
  vpc_id = aws_vpc.myvpc.id
  tags = {
    Name = "myigw"
  }
}
 
# Step 3
resource "aws_subnet" "mysubnet" {
  vpc_id     = aws_vpc.myvpc.id
  cidr_block = "10.0.0.0/24"

  tags = {
    Name = "mysubnet"
  }
}

# Step 4
resource "aws_route_table" "myrtb" {
vpc_id = "${aws_vpc.myvpc.id}"
 route {
 cidr_block = "0.0.0.0/0"
 gateway_id = "${aws_internet_gateway.myigw.id}"
 }
 tags = {
 Name = "myrtb"
 }
}

# Step 5
resource "aws_route_table_association" "myrtba" {
 subnet_id = aws_subnet.mysubnet.id
 route_table_id = aws_route_table.myrtb.id
}

########### Security ################
# Step 1
resource "aws_security_group" "mysg" {
  name        = "mysg"
  description = "Allow all traffic"
  vpc_id      = aws_vpc.myvpc.id
variable "myregion"{
type = string
}

variable "myami"{
type = string
}

variable "mypublickey"{
type = string
}

variable "jenkins_count"{
type = string
}

variable "artifactory_count"{
type = string
}

variable "webapp_count"{
type = string
}

################ Authentication ##########33
provider "aws" {
    region = var.myregion
}

#########  Networking ##############
# Step 1
resource "aws_vpc" "myvpc" {
    cidr_block = "10.0.0.0/16"
    tags = {
      "Name" = "myvpc"
    }

}

# Step 2
resource "aws_internet_gateway" "myigw" {
  vpc_id = aws_vpc.myvpc.id
  tags = {
    Name = "myigw"
  }
}
 
# Step 3
resource "aws_subnet" "mysubnet" {
  vpc_id     = aws_vpc.myvpc.id
  cidr_block = "10.0.0.0/24"

  tags = {
    Name = "mysubnet"
  }
}

# Step 4
resource "aws_route_table" "myrtb" {
vpc_id = "${aws_vpc.myvpc.id}"
 route {
 cidr_block = "0.0.0.0/0"
 gateway_id = "${aws_internet_gateway.myigw.id}"
 }
 tags = {
 Name = "myrtb"
 }
}

# Step 5
resource "aws_route_table_association" "myrtba" {
 subnet_id = aws_subnet.mysubnet.id
 route_table_id = aws_route_table.myrtb.id
}

########### Security ################
# Step 1
resource "aws_security_group" "mysg" {
  name        = "mysg"
  description = "Allow all traffic"
  vpc_id      = aws_vpc.myvpc.id

  ingress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]

  }

  tags = {
    Name = "mysg"
  }
}

# Step 2
resource "aws_key_pair" "mykp" {
  key_name   = "mykp"
  public_key = var.mypublickey
}

###############  Computing ############
resource "aws_instance" "jenkins" {
  count = var.jenkins_count
  ami           = var.myami
  associate_public_ip_address = "true"
  vpc_security_group_ids = [aws_security_group.mysg.id]
  key_name = "mykp"
  subnet_id = aws_subnet.mysubnet.id
  instance_type = "t2.micro"
  tags = {
    Name = "jenkins-server"
  }
}

resource "aws_instance" "artifactory" {
  count = var.artifactory_count
  ami           = var.myami
  associate_public_ip_address = "true"
  vpc_security_group_ids = [aws_security_group.mysg.id]
  key_name = "mykp"
  subnet_id = aws_subnet.mysubnet.id
  instance_type = "t2.medium"
  tags = {
    Name = "artifactory-server"
  }
}

resource "aws_instance" "webapp" {
  count = var.webapp_count
  ami           = var.myami
  associate_public_ip_address = "true"
  vpc_security_group_ids = [aws_security_group.mysg.id]
  key_name = "mykp"
  subnet_id = aws_subnet.mysubnet.id
  instance_type = "t2.micro"
  tags = {
    Name = "webapp-server"
  }
}
 
  ingress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]

  }

  tags = {
    Name = "mysg"
  }
}

# Step 2
resource "aws_key_pair" "mykp" {
  key_name   = "mykp"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDYZi3tC+HbVFVuaxLtA92jAsAqtnDUKrrDNUdFY6sSx1ayaCyJeTW+GKvISl+fW06KqfvDw0hNbb0+vex79ghwEfBVfUnBTgGZWcCWMY3gTK1JoPb7ci2zwWUNrw6sFKVHw5UADLGc8dX8S+RQo3BBRenfti2mHjR1LRWY9PJGbjlkR+enM22FowN7fG6SLL+FK7iWYBx0tNWfnrPq6Huh/U74eSPD7kYXtTXlJyrgocqeg9V4BxCeH6yzOmvTEf9J11CQTOR+iKkEQB6n1YS/aaMdBlChgD34O001eEsKe3pSKvLLuqsqXwOpRA2pL8rM/Tx6pCdJE6gRal++IcKqbyOablm7/0110XomEWtqaLJgXy8FbYX3XPhYvX8dB5V+6v0tUsjaj/DTGETbzwRuYbxsh5+Uj036QNzw1VO3x00K9ch2IppVCY9/cK909EgwMrO35dR/hrc9dZztEYnioqlp7FKrDYOX+usbIkuxe4BcJdTq8O4zHf1LgFhZnn0= jyoth@jojo"
}

###############  Computing ############
resource "aws_instance" "my" {
  ami           = "ami-002070d43b0a4f171"
  associate_public_ip_address = "true"
  vpc_security_group_ids = [aws_security_group.mysg.id]

  key_name = "mykp"

  subnet_id = aws_subnet.mysubnet.id
  instance_type = "t2.micro"
  tags = {
    Name = "mywebserver"
  }
}


 
