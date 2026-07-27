variable "project_name" {
  description = "Name prefix used for tagging all resources in this VPC"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "public_subnet_1_cidr" {
  description = "CIDR block for the first public subnet"
  type        = string
}

variable "public_subnet_2_cidr" {
  description = "CIDR block for the second public subnet"
  type        = string
}

variable "private_subnet_1_cidr" {
  description = "CIDR block for the first private subnet"
  type        = string
}

variable "private_subnet_2_cidr" {
  description = "CIDR block for the second private subnet"
  type        = string
}

variable "az_1" {
  description = "First availability zone"
  type        = string
}

variable "az_2" {
  description = "Second availability zone"
  type        = string
}
variable "my_ip_cidr" {
  description = "Your IP address in CIDR notation, for SSH access"
  type        = string
}
