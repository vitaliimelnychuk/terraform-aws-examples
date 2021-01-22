# terraform-aws-ecs-service

Terraform module to create ECS service

## Example of usage

```HCL
terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

provider "aws" {
  profile = "terraform-example"
  region  = "us-east-1"
}

module "api_prod" {
  source               = "./ecs-service
  env                  = "production"
  route53_hosting_zone = "example.com"
  root_domain_name     = "api.example.com"
  app_name             = "example"
  app_port             = 4000
  aws_vpc              = aws_vpc.main
  aws_subnet_public    = aws_subnet.public
}

```
