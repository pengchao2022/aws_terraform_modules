variable "api_name" {
  description = "The name of the API Gateway"
  type        = string
  
}

variable "lambda_invoke_arn" {
  description = "The invoke ARN of the Lambda function"
  type        = string
  
}

variable "lambda_function_name" {
  description = "The name of the Lambda function"
  type        = string
  
}

variable "create_iam_resources" {
  description = "Set to true to create the API Gateway CloudWatch role and account settings. Set to false if already managed elsewhere."
  type        = bool
  default     = false
}