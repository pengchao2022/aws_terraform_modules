# create iam role for API Gateway
resource "aws_iam_role" "api_gateway_cloudwatch_role" {
  count = var.create_iam_resources ? 1 : 0
  name  = "api_gateway_cloudwatch_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = { Service = "apigateway.amazonaws.com" }
    }]
  })
}

# IAM Policy Attachment give api gateway to write to cloudwatch permission
resource "aws_iam_role_policy_attachment" "api_gateway_cloudwatch_logs" {
  count      = var.create_iam_resources ? 1 : 0
  role       = aws_iam_role.api_gateway_cloudwatch_role[0].name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonAPIGatewayPushToCloudWatchLogs"
}

# bind account and role 
resource "aws_api_gateway_account" "this" {
  count               = var.create_iam_resources ? 1 : 0
  cloudwatch_role_arn = aws_iam_role.api_gateway_cloudwatch_role[0].arn
  depends_on = [aws_iam_role_policy_attachment.api_gateway_cloudwatch_logs]
}