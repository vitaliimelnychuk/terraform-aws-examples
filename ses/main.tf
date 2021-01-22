
resource "aws_ses_domain_identity" "ses_domain" {
  count  = 1
  domain = var.domain
}

resource "aws_route53_record" "amazonses_verification_record" {
  count   = 1
  zone_id = var.zone_id
  name    = "_amazonses.${var.domain}"
  type    = "TXT"
  ttl     = "600"
  records = [join("", aws_ses_domain_identity.ses_domain.*.verification_token)]
}

resource "aws_ses_domain_dkim" "ses_domain_dkim" {
  count  = 1
  domain = join("", aws_ses_domain_identity.ses_domain.*.domain)
}

resource "aws_route53_record" "amazonses_dkim_record" {
  count = 3

  zone_id = var.zone_id
  name    = "${element(aws_ses_domain_dkim.ses_domain_dkim.0.dkim_tokens, count.index)}._domainkey.${var.domain}"
  type    = "CNAME"
  ttl     = "600"
  records = ["${element(aws_ses_domain_dkim.ses_domain_dkim.0.dkim_tokens, count.index)}.dkim.amazonses.com"]
}
