# Remote state backend (this block is read by Terraform CLI; variables used are local).
# Note: When first creating the bucket used for state, you may need to use local state to create it, then reconfigure backend.
terraform {
  backend "s3" {
    bucket         = var.tfstate_bucket
    key            = "infra/terraform.tfstate"
    region         = var.aws_region
    dynamodb_table = var.tfstate_lock_table
    encrypt        = true
  }
}
