resource "aws_s3_bucket" "main" {
  bucket = var.bucket_name
  tags = var.tags
  
}

# enable version control to prevent delete data accidently
resource "aws_s3_bucket_versioning" "main" {
  bucket = aws_s3_bucket.main.id
  versioning_configuration {
    status = "Enabled"
  }
  
}

# enable s3 static website if you need
resource "aws_s3_bucket_website_configuration" "main" {
  # ? is ternary conditional operator 三元条件运算
  # if var.enable_website is true then count = 1 will create the website
  # if var.enable_website is false then count = 0 will create nothing 
  bucket = aws_s3_bucket.main.id
  count = var.enable_website ? 1 : 0   

  index_document {
    suffix = "index.html"
  }  
}

# encryption
resource "aws_s3_bucket_server_side_encryption_configuration" "main" {
  bucket = aws_s3_bucket.main.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  } 
}

# public access blocked by default also fit for s3 static website using
resource "aws_s3_bucket_public_access_block" "main" {
  bucket = aws_s3_bucket.main.id

  # if enable_website is true then block_public_acls  will be false
  block_public_acls       = var.enable_website ? false : true
  block_public_policy     = var.enable_website ? false : true
  ignore_public_acls      = var.enable_website ? false : true
  restrict_public_buckets = var.enable_website ? false : true
}

# add bucket policy to allow all people can access this website
resource "aws_s3_bucket_policy" "public_read" {
  count  = var.enable_website ? 1 : 0 # only is s3 website then will create this policy
  bucket = aws_s3_bucket.main.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid           = "PublicReadGetObject"
        Effect        = "Allow"
        Action        = "s3:GetObject"
        Resource      = "${aws_s3_bucket.main.arn}/*"
      },
    ]
  })

  # The policy must be applied after public_access_block
  depends_on = [aws_s3_bucket.public_access_block.main]
  
}