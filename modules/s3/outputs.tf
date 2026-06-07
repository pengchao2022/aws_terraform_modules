output "bucket_arn" {
  value = aws_s3_bucket.main.arn
  description = "S3 bucket ARN"
}

output "bucket_id" {
  value = aws_s3_bucket.main.id
  description = "Name of the S3 bucket"  # for s3 bucket, the bucket_id is also the name
}

output "website_url"{
  description = "The URL of the static website"
  value = var.enable_website ? "http://${aws_s3_bucket.main.id}.s3-website-us-east-1.amazonaws.com" : "Website not enabled"
}