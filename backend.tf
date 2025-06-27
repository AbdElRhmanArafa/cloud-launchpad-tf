terraform {
  backend "s3" {
    bucket = "my-terraform-state"
    key    = "terraform.tfstate"
    region = "us-east-1"
    workspace_key_prefix = "terraform/workspaces"
  }
}
