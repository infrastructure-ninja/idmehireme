provider "google" {
  project = var.gcp_project_id
  region  = var.gcp_project_region
}

provider "aws" {
  region     = var.aws_region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}
