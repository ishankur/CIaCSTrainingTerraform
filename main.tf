variable "awsprops" {
    type = map
    default = {
    region = "ap-southeast-1"
    vpc = "vpc-0dda41b96fdea0b35"
    ami = "ami-01938df366ac2d954"
    itype = "t2.micro"
    subnet = "subnet-09fd907683b07ea88"
    publicip = true
    keyname = "IshanSingapore"
    secgroupname = "launch-wizard-1"
  }
}

provider "aws" {
  region = lookup(var.awsprops, "region")
}

resource "aws_security_group" "ciacs-sg" {
  name = lookup(var.awsprops, "secgroupname")
  description = lookup(var.awsprops, "secgroupname")
  vpc_id = lookup(var.awsprops, "vpc")

  // To Allow SSH Transport
  ingress {
    from_port = 22
    protocol = "tcp"
    to_port = 22
    cidr_blocks = ["0.0.0.0/0"]
  }

  // To Allow Port 80 Transport
  ingress {
    from_port = 80
    protocol = "tcp"
    to_port = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  lifecycle {
    create_before_destroy = true
  }
}


resource "aws_instance" "ciacs" {
  ami = lookup(var.awsprops, "ami")
  instance_type = lookup(var.awsprops, "itype")
  subnet_id = lookup(var.awsprops, "subnet") #FFXsubnet2
  associate_public_ip_address = lookup(var.awsprops, "publicip")
  key_name = lookup(var.awsprops, "keyname")

  user_data = file("init-script.sh")

    
  vpc_security_group_ids = [
    aws_security_group.ciacs-sg.id
  ]

  tags = {
    Name ="IaCAppServer"
  }

  depends_on = [ aws_security_group.ciacs-sg ]
}


output "ec2instance" {
  value = aws_instance.ciacs.public_ip
}

output "websiterul" {
  value = format("http://%s/cafe", aws_instance.ciacs.public_ip)
}
