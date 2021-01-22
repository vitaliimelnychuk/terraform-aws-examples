output "alb_hostname" {
  value = aws_alb.main.dns_name
}

output "ecr_image_repository_url" {
  value = aws_ecr_repository.main.repository_url
}
