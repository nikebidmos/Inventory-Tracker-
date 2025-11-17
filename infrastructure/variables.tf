variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "vpc_cidr" {
  type    = string
  default = "10.10.0.0/16"
}

variable "public_subnet_cidrs" {
  type = list(string)
  default = ["10.10.1.0/24", "10.10.2.0/24"]
}

variable "private_subnet_cidrs" {
  type = list(string)
  default = ["10.10.11.0/24", "10.10.12.0/24"]
}

variable "instance_type" {
  type    = string
  default = "t3.micro"
}

variable "ami_id" {
  type    = string
  default = "" # set a region-appropriate linux AMI (Amazon Linux 2 or Ubuntu). Example: "ami-0c02fb55956c7d316"
}

variable "key_pair_name" {
  type = string
  description = "An existing EC2 key pair name to allow SSH from CI for deployment"
  default = ""
}

variable "db_username" {
  type    = string
  default = "inventory_admin"
}

variable "db_password" {
  type    = string
  default = "CHANGE_ME" # override with TF_VAR_db_password or secret
}

variable "tfstate_bucket" {
  type = string
  default = "inventory-tfstate-your-unique-bucket"
}

variable "tfstate_lock_table" {
  type = string
  default = "inventory-tf-locks"
}
