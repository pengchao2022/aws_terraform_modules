output "lambda_arn" {
  description = "The ARN of the lambda function"
  value       = aws_lambda_function.this.arn 
  
}

output "lambda_name" {
  description = "The name of the Lambda function"
  value       = aws_lambda_function.this.function_name 
}

output "lambda_invoke_arn" {
  description = "THe Invoke ARN of the lambda function"
  value       = aws_lambda_function.this.invoke_arn
  
}