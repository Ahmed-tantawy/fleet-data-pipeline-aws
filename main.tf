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
    description = "SSH from my IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.my_ip_cidr]
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
