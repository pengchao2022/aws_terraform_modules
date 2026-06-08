data "archive_file" "lambda_zip" {
  type        = "zip"
  source_file = var.source_file
  output_path = "${var.function_name}.zip"
  
}

resource "aws_lambda_function" "this" {
  filename      = data.archive_file.lambda_zip.output_path
  function_name = var.function_name
  role          = aws_iam_role.lambda_role.arn
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.9"

  source_code_hash = data.archive_file.lambda_zip.output_base64sha256

  environment {
    variables = { TABLE_NAME = var.table_name }
  }
  
}

# enable cloudwatch
resource "aws_cloudwatch_log_group" "this" {
  name              = "/aws/lambda/${var.function_name}"
  retention_in_days = 7
}