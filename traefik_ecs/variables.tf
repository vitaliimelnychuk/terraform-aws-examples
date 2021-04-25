variable "vpc_id" {
  default = ""
}

variable "namespace" {
  default = "traefik"
}

variable "subnets" {
  type    = list
  default = [""]
}

variable "access_key" {
  default = ""
}

variable "secret_access_key_id" {
  default = ""
}
