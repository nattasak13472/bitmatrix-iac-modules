# CloudFront Distribution Module

This module manages an AWS CloudFront distribution, primarily optimized for use as a Content Delivery Network (CDN) in front of an Application Load Balancer (ALB).

## 🚀 Example Usage

### 1. CloudFront with Internal ALB (Standard Web App)
This is the recommended architecture for security. Your ALB stays private (internal), and CloudFront is the only public entry point.

```hcl
# 1. Setup the Internal ALB
module "internal_alb" {
  source   = "../../networking/alb"
  internal = true
  # ... other inputs
}

# 2. Setup CloudFront pointing to that ALB
module "cdn" {
  source = "../../networking/cloudfront"

  project       = "bitmatrix"
  environment   = "nonprod"
  domain_name   = "app.bitmatrix.com"
  resource_name = "app"
  
  # Point to the ALB DNS name
  origin_domain_name = module.internal_alb.alb_dns_name
  origin_id          = "InternalAppALB"
  
  # ACM Certificate (Must be in us-east-1 for CloudFront)
  acm_certificate_arn = "arn:aws:acm:us-east-1:123456789012:certificate/..."
}
```

## 🛡 Security Integration
For a production setup with ECS:
1.  **Origin Access**: You can configure your Internal ALB security group to only allow traffic from CloudFront IP ranges (using the `aws_ec2_managed_prefix_list` for CloudFront).
2.  **WAF**: You can attach an AWS WAF Web ACL to this distribution by adding the `waf_acl_id` property (if extended in the module).
3.  **HTTPS**: This module enforces `https-only` between CloudFront and the ALB for maximum security.

## ⚠️ Important Note on ACM
AWS requires that certificates used with CloudFront distributions be created in the **`us-east-1`** (N. Virginia) region, regardless of where your ALB or ECS service is located.
