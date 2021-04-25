variable "env" {
  description = "Backend ECS environment"
}

variable "app" {
  description = "Unique application name that would be attached as tag for all resources"
}


variable "root_domain_name" {
  description = "Domain where Website should be available to use along with certificates"
}

variable "route53_hosting_zone_id" {
  description = "AWS Route53 hosring zone ID"
}
