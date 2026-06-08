variable "function_name" {
  description = "The name of the Lambda function"
  type        = string
  
}

variable "table_name" {
  description = "The name of the DynamoDB table"
  type        = string
  
}

variable "table_arn" {
  description = "The ARN of the DynamoDB table"
  type        = string
  
}

variable "source_file" {
  description = "The path to the Lambda function source code file"
  type        = string
  
}

