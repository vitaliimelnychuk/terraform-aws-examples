
data "archive_file" "lambda_zip" {
  type        = "zip"
  output_path = "${path.module}/files/s3-basic-auth.zip"

  source {
    content  = file("${path.module}/files/s3-basic-auth-lambda/index.js")
    filename = "index.js"
  }
}

resource "aws_iam_role" "iam_for_lambda" {
  name = "iam_for_lambda"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": ["lambda.amazonaws.com", "edgelambda.amazonaws.com"] 
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_lambda_function" "s3_basic_auth" {
  filename      = "${path.module}/files/s3-basic-auth.zip"
  function_name = "s3-basic-auth"
  role          = aws_iam_role.iam_for_lambda.arn
  handler       = "index.handler"

  source_code_hash = filebase64sha256("${path.module}/files/s3-basic-auth.zip")

  runtime = "nodejs12.x"

  publish = true

  tags = {
    ENV = var.env
    APP = var.app
  }
}


resource "aws_cloudfront_distribution" "www_private_distribution" {
  origin {
    custom_origin_config {
      http_port              = "80"
      https_port             = "443"
      origin_protocol_policy = "http-only"
      origin_ssl_protocols   = ["TLSv1", "TLSv1.1", "TLSv1.2"]
    }

    domain_name = aws_s3_bucket.www.website_endpoint

    origin_id = var.root_domain_name
  }

  enabled             = true
  default_root_object = "index.html"

  default_cache_behavior {
    viewer_protocol_policy = "redirect-to-https"
    compress               = true
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]
    // This needs to match the `origin_id` above.
    target_origin_id = var.root_domain_name
    min_ttl          = 0
    default_ttl      = 86400
    max_ttl          = 31536000

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }

    lambda_function_association {
      event_type   = "viewer-request"
      lambda_arn   = aws_lambda_function.s3_basic_auth.qualified_arn
      include_body = false
    }
  }

  aliases = [var.root_domain_name]

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn = aws_acm_certificate.certificate.arn
    ssl_support_method  = "sni-only"
  }

  tags = {
    ENV = var.env
    APP = var.app
  }
}


resource "aws_route53_record" "private_website_cdn_redirect_record" {
  zone_id = var.route53_hosting_zone_id
  name    = var.root_domain_name
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.www_private_distribution.domain_name
    zone_id                = aws_cloudfront_distribution.www_private_distribution.hosted_zone_id
    evaluate_target_health = false
  }

  depends_on = [
    aws_cloudfront_distribution.www_private_distribution
  ]

}
