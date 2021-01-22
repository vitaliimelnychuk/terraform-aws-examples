# terraform-aws-static-website

Terraform module to provision an AWS static website using Route53, S3, and CloudFront.

## Example of usage

In order to use this package you have to initialize this module in your terraform setup.

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


module "frontend_prod" {
  source = "./aws-static-website"

  route53_hosting_zone = "example.com"
  root_domain_name     = "example.com"
}

```
