variable "env" {
  description = "Backend ECS environment"
}

variable "app" {
  description = "Unique application name that would be attached as tag for all resources"
}

variable "aws_region" {
  description = "The AWS region to create things in."
  default     = "us-east-1"
}

variable "aws_subnet_public" {
  description = "AWS subnet"
}

variable "aws_vpc" {
  description = "AWS VPC"
}

variable "root_domain_name" {
  description = "Domain when Backend should be available to use along with certificates"
}

variable "route53_hosting_zone_id" {
  description = "AWS Route53 hosring zone ID"
}

variable "resources_prefix" {
  description = "Prefix that would be attached for all resources that have to be created"
}

variable "ecs_services" {
  description = "List of application services that should be created"
  type = list(object({
    service_name = string
    app_count    = number
  }))
  default = []
}


variable "traefik_access_key" {
  description = "Traefik Access key with access to ECS cluster"
  type        = string
  sensitive   = true
}

variable "traefik_secret_access_key_id" {
  description = "Traefik secret key with access to ECS cluster"
  type        = string
  sensitive   = true
}

