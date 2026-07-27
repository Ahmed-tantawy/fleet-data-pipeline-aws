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
