variable "aws_region" {
  description = "The AWS region to create things in."
  default     = "us-east-1"
}

variable "root_domain_name" {
  description = "Domain when Backend should be available to use along with certificates"
}

variable "route53_hosting_zone" {
  description = "AWS Route53 hosring zone"
}

variable "env" {
  description = "Backend ECS environment"
}

variable "app_name" {
  description = "Application name"
}

variable "app_image" {
  description = "Docker image to run in the ECS cluster"
  default     = "adongy/hostname-docker:latest"
}

variable "app_port" {
  description = "Port exposed by the docker image to redirect traffic to"
  default     = 3000
}

variable "app_count" {
  description = "Number of docker containers to run"
  default     = 2
}

variable "fargate_cpu" {
  description = "Fargate instance CPU units to provision (1 vCPU = 1024 CPU units)"
  default     = "256"
}

variable "fargate_memory" {
  description = "Fargate instance memory to provision (in MiB)"
  default     = "512"
}

variable "aws_subnet_public" {
  description = "AWS subnet"
}

variable "aws_vpc" {
  description = "AWS VPC"
}
