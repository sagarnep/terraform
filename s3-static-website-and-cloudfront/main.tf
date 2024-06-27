provider "aws" {
    region = var.region
}

resource "aws_s3_bucket" "this" {
    bucket = var.s3-bucket
}

resource "aws_s3_bucket_acl" "this" {
    bcuket = aws_s3_bucket.this.id
    acl = "private"
}

resource "aws_s3_bucket_configuration" "this" {
    bucket = aws_s3_bucket.this.bucket 

    index_document {
        suffix = "index.html"
    }

    error_document {
        key = "index.html"
    }

}

resource "aws_s3_bucket_policy" "this" {
    bucket = aws_s3_bucket.this.id
    
    policy = jsonencode ({
        Version = "2012-10-17"
        Id      = "AllowGetObjects"
        Statement = [
            {
                Sid = "AllowPublic"
                Effect = "Allow"
                Principal = "*"
                Action = "s3:GetObject"
                Resource ="${aws_s3_bucket.this.arn}/**"
            }
        ]
    })
}

resource "aws_cloudfront_distribution" "distribution" {
    origin {
        domain_name = aws_s3_bucket.this.bucket_regional_domain_name
        origin_access_control_id = aws_cloudfront_origin_access_control.default
        origin_id = local.s3_origin_id
    }

    enabled = true
    is_ipv6_enabled = true
    comment = "This is my cache access website"
    default_root_object = "index.html"

    aliases = ["firstwebsite.com"]

    default_cache_behavior {
        allowed_methods = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST"]
        cached_methods = ["GET", "HEAD"]
        target_origin_id = local.s3_origin.id
    }

    restriction {
        geo_restriction {
            restriction_type = "whitelist"
            locations = ["US", "CA", "GB", "DE"]
        }
    }

    tags = {
        Environment = "production"
    }

    viewer_certificate {

        cloudfront_default_certificate = true
    }