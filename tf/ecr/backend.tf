# Backend
terraform {
  backend "remote" {
    hostname = "app.terraform.io"
    organization = "michaelecs"
    workspaces {
      name = "ecr"
    }
  }
}