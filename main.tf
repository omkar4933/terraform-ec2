locals {
  subnets_tags = {
    Name      = "tf-workshop-sn-1a"
    Funcation = "Workshop"
  }

  sg_tags = {
    Name      = "tf-workshop-sg"
    Funcation = "Workshop"
  }

  ec2_tags = {
    Name      = "tf-workshop-ec2"
    Funcation = "Workshop"
  }
}

module "subnet" {
  source            = "./modules/subnet"
  vpc_id            = data.aws_vpc.test_vpc.id
  cidr_block        = var.cidr_block
  tags              = local.subnets_tags
  availability_zone = var.availability_zone
  route_table_id    = data.aws_route_table.default.id
}

resource "aws_security_group" "main" {
  name        = "tf-workshop-sg"
  vpc_id      = data.aws_vpc.test_vpc.id
  description = "Allow SSH access"
  ingress {
    to_port     = 22
    from_port   = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = local.sg_tags
}

resource "aws_instance" "main" {
  ami                         = var.ami_id
  instance_type               = "t2.micro"
  associate_public_ip_address = true
  key_name                    = var.key_name
  subnet_id                   = module.subnet.id
  vpc_security_group_ids      = [aws_security_group.main.id]
  tags                        = local.ec2_tags
}
