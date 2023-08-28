
# for kops state
resource "aws_s3_bucket" "kops_state_store" {
  bucket = "kops-papavonning"
}

# resource "aws_s3_bucket_acl" "state_acl" {
#   bucket = aws_s3_bucket.kops_state_store.id
#   acl = "private"
# }

resource "aws_s3_bucket_versioning" "state_version" {
  bucket = aws_s3_bucket.kops_state_store.id
  versioning_configuration {
    status = "Enabled"
  }
}

output "s3_bucket_arn_kops" {
  value = aws_s3_bucket.kops_state_store.arn
}

output "s3_bucket_endpoint_kops" {
  value = aws_s3_bucket.kops_state_store.bucket_regional_domain_name
}

output "s3_name_kops" { 
  value = aws_s3_bucket.kops_state_store.bucket_domain_name
}

# for OICD
resource "aws_s3_bucket" "oidc_store" {
  bucket = "oidc-papavonning"

}

# resource "aws_s3_bucket_acl" "oidc_acl" {
#   bucket= aws_s3_bucket.oidc_store.id
#   acl = "public-read"
# }

resource "aws_s3_bucket_server_side_encryption_configuration" "oicd" {
  bucket = aws_s3_bucket.oidc_store.id
  rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
}

resource "aws_s3_bucket_ownership_controls" "oidc_control" {
  bucket = aws_s3_bucket.oidc_store.id
  rule {
      object_ownership = "BucketOwnerPreferred"
    }
}

resource "aws_s3_bucket_public_access_block" "oidc_access_block" {
  bucket = aws_s3_bucket.oidc_store.id
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_acl" "oidc_acl" {
  bucket= aws_s3_bucket.oidc_store.id
  acl = "public-read"

  depends_on = [ 
    aws_s3_bucket_ownership_controls.oidc_control,
    aws_s3_bucket_public_access_block.oidc_access_block
   ]            

}



output "s3_bucket_arn_OIDC" {
  value = aws_s3_bucket.oidc_store.arn
}

output "s3_bucket_endpoint_OIDC" {
  value = aws_s3_bucket.oidc_store.bucket_regional_domain_name
}

output "s3_name_OIDC" { 
  value = aws_s3_bucket.oidc_store.bucket_domain_name
}









