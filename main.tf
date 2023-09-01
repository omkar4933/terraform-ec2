locals {
  subnets_tags = {
    Name      = "subnet-1a"
    Funcation = "Workshop"
  }

  sg_tags = {
    Name      = "om-sg"
    Funcation = "Workshop"
  }

  ec2_tags = {
    Name      = "my-ec2"
    Funcation = "Workshop"
  }
}

module "subnet" {
  source            = "./modules/subnet"
  vpc_id            = data.aws_vpc.test_vpc.id
  cidr_block        = var.cidr_block1
  tags              = local.subnets_tags
  availability_zone = var.availability_zone
  route_table_id    = data.aws_route_table.default.id
}



resource "aws_instance" "main" {
  ami                         = var.ami_id
  instance_type               = "t2.micro"
  associate_public_ip_address = true
  key_name                    = var.key_name
  subnet_id                   = module.subnet.id
  vpc_security_group_ids = [
    aws_security_group.allow_to_myip.id,
    aws_security_group.internal_sg.id
  ]
  tags      = local.ec2_tags
  user_data = file("script.sh")
}

resource "aws_eip" "my_eip" {
  instance = aws_instance.main.id
}

resource "aws_ebs_volume" "main_vol_1" {
  availability_zone = var.availability_zone
  size              = 8
  type              = "gp2"
}


resource "aws_ebs_volume" "main_vol_2" {
  availability_zone = var.availability_zone
  size              = 8
  type              = "gp3"
}


resource "aws_volume_attachment" "vol_attachment_1" {
  device_name = "/dev/sdc"
  volume_id   = aws_ebs_volume.main_vol_1.id
  instance_id = aws_instance.main.id
}

resource "aws_volume_attachment" "vol_attachment_2" {
  device_name = "/dev/sdb"
  volume_id   = aws_ebs_volume.main_vol_2.id
  instance_id = aws_instance.main.id
}

resource "aws_security_group" "allow_to_myip" {
  name        = "allow_to_myip"
  description = "allow_to_myip"

  ingress {
    description = "allow_to_myip"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.my_ip]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "internal_sg" {
  name        = "internal-sg"
  description = "internal-sg"
  // Allow internal traffic
  ingress {
    from_port = 0
    to_port   = 65535
    protocol  = "tcp"
    self      = true
  }

  egress {
    from_port = 0
    to_port   = 65535
    protocol  = "tcp"
    self      = true
  }
}