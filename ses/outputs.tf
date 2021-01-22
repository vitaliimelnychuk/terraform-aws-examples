output "ses_domain_identity_arn" {
  value       = try(aws_ses_domain_identity.ses_domain[0].arn, "")
  description = "The ARN of the SES domain identity"
}

output "ses_domain_identity_verification_token" {
  value       = try(aws_ses_domain_identity.ses_domain[0].verification_token, "")
  description = "A code which when added to the domain as a TXT record will signal to SES that the owner of the domain has authorised SES to act on their behalf. The domain identity will be in state 'verification pending' until this is done. See below for an example of how this might be achieved when the domain is hosted in Route 53 and managed by Terraform. Find out more about verifying domains in Amazon SES in the AWS SES docs."
}
