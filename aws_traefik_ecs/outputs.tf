output "dashboard_url" {
    value = join("", ["http://", aws_lb.traefik.dns_name, ":8080"])
}

output "whoami" {
    value = join("", ["http://", aws_lb.traefik.dns_name])
}