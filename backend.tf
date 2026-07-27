terraform {
  backend "s3" {
    bucket       = "fleet-pipeline-tfstate-atantawy"
    key          = "foundation/terraform.tfstate"
    region       = "eu-central-1"
    use_lockfile = true
    encrypt      = true
  }
}
