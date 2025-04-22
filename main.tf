variable "awsprops" {
    type = map
    default = {
    region = "ap-southeast-2"
    vpc = "vpc-06da4dddeefad6821"
    ami = "ami-0f5d1713c9af4fe30"
    itype = "t2.micro"
    subnet = "subnet-09f20f2d2d18a5d5e"
    publicip = true
    keyname = "Verity77ppkSydney"
    secgroupname = "VerityAppSecGrp"
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

  user_data = "${file("init-script.sh")}"
    
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
  value = format("%s%s", aws_instance.ciacs.public_ip, "/cafe")
}
