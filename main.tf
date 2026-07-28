moved {
  from = aws_vpc.fleet
  to   = module.vpc.aws_vpc.this
}

moved {
  from = aws_subnet.public_1a
  to   = module.vpc.aws_subnet.public_1a
}

moved {
  from = aws_subnet.public_1b
  to   = module.vpc.aws_subnet.public_1b
}

moved {
  from = aws_subnet.private_1a
  to   = module.vpc.aws_subnet.private_1a
}

moved {
  from = aws_subnet.private_1b
  to   = module.vpc.aws_subnet.private_1b
}

moved {
  from = aws_internet_gateway.fleet
  to   = module.vpc.aws_internet_gateway.this
}

moved {
  from = aws_eip.nat
  to   = module.vpc.aws_eip.nat
}

moved {
  from = aws_nat_gateway.fleet
  to   = module.vpc.aws_nat_gateway.this
}

moved {
  from = aws_route_table.public
  to   = module.vpc.aws_route_table.public
}

moved {
  from = aws_route_table.private
  to   = module.vpc.aws_route_table.private
}

moved {
  from = aws_route_table_association.public_1a
  to   = module.vpc.aws_route_table_association.public_1a
}

moved {
  from = aws_route_table_association.public_1b
  to   = module.vpc.aws_route_table_association.public_1b
}

moved {
  from = aws_route_table_association.private_1a
  to   = module.vpc.aws_route_table_association.private_1a
}

moved {
  from = aws_route_table_association.private_1b
  to   = module.vpc.aws_route_table_association.private_1b
}


module "vpc" {
  source = "./modules/vpc"

  project_name = "fleet-pipeline"
  vpc_cidr     = "10.0.0.0/16"

  public_subnet_1_cidr  = "10.0.0.0/24"
  public_subnet_2_cidr  = "10.0.1.0/24"
  private_subnet_1_cidr = "10.0.10.0/24"
  private_subnet_2_cidr = "10.0.11.0/24"

  az_1 = "eu-central-1a"
  az_2 = "eu-central-1b"
}

resource "aws_security_group" "ansible_target" {
  name        = "fleet-ansible-target-sg"
  description = "Allow SSH from my IP for Ansible lab"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description = "SSH temporarily open - TIGHTEN BEFORE MOVING ON"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "fleet-ansible-target-sg"
  }
}

data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_instance" "ansible_target" {
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = "t3.micro"
  subnet_id              = module.vpc.public_subnet_ids[0]
  key_name               = aws_key_pair.ansible.key_name
  vpc_security_group_ids = [aws_security_group.ansible_target.id]

  associate_public_ip_address = true

  tags = {
    Name = "fleet-ansible-target"
  }
}

resource "tls_private_key" "ansible_ssh" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "ansible" {
  key_name   = "fleet-ansible-key"
  public_key = tls_private_key.ansible_ssh.public_key_openssh
}
