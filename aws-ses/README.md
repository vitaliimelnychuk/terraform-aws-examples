# terraform-aws-ses

Terraform module to configure a domain hosted on Route53 to work with AWS Simple Email Service (SES).

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


data "aws_route53_zone" "example" {
  name         = "example.com"
  private_zone = false
}

module "ses_prod" {
  source = "./aws-ses"

  domain  = "example.com"
  zone_id = data.aws_route53_zone.example.zone_id
}

```
