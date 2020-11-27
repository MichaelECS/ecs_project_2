# Backend
terraform {
  backend "remote" {
    hostname = "app.terraform.io"
    organization = "michaelecs"
    workspaces {
      name = "ecs_project_2"
    }
  }
}