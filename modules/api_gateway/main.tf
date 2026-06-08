# define API
resource "aws_api_gateway_rest_api" "this" {
  name = var.api_name
}

# define resource (path: /visit)
resource "aws_api_gateway_resource" "visit" {
  rest_api_id = aws_api_gateway_rest_api.this.id
  parent_id   = aws_api_gateway_rest_api.this.root_resource_id
  path_part   = "visit"
 
}

# define method (POST)
resource "aws_api_gateway_method" "post" {
  rest_api_id = aws_api_gateway_rest_api.this.id
  resource_id = aws_api_gateway_resource.visit.id
  http_method = "POST"
  authorization = "NONE"
  
}

# define intergration (point to lambda)
resource "aws_api_gateway_integration" "lambda" {
  rest_api_id = aws_api_gateway_rest_api.this.id
  resource_id = aws_api_gateway_resource.visit.id
  http_method = aws_api_gateway_method.post.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = var.lambda_invoke_arn
  
}

# deploy API
resource "aws_api_gateway_deployment" "this" {
  depends_on = [ 
    aws_api_gateway_integration.lambda,
    aws_api_gateway_integration.options
  ]
  rest_api_id = aws_api_gateway_rest_api.this.id
  
  triggers = {
    redeployment = sha1(jsonencode(aws_api_gateway_rest_api.this.body))
  }

  lifecycle {
    create_before_destroy = true
  }

}

# define stage
resource "aws_api_gateway_stage" "prod" {
  deployment_id = aws_api_gateway_deployment.this.id
  rest_api_id = aws_api_gateway_rest_api.this.id
  stage_name = "prod"
  
}

# give API Gateway the privilege to call lambda
resource "aws_lambda_permission" "apigw" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.this.execution_arn}/*/*"  
}

# added OPTIONS method
resource "aws_api_gateway_method" "options" {
  rest_api_id    = aws_api_gateway_rest_api.this.id
  resource_id    = aws_api_gateway_resource.visit.id
  http_method    = "OPTIONS"
  authorization  = "NONE"

  
}

# response configure
resource "aws_api_gateway_method_response" "option_200" {
  rest_api_id = aws_api_gateway_rest_api.this.id 
  resource_id = aws_api_gateway_resource.visit.id
  http_method = aws_api_gateway_method.options.http_method
  status_code = "200"
  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin"  = true,
    "method.response.header.Access-Control-Allow-Methods" = true,
    "method.response.header.Access-Control-Allow-Headers" = true
  }
}

# OPTIONS method 
resource "aws_api_gateway_integration" "options" {
  rest_api_id = aws_api_gateway_rest_api.this.id
  resource_id = aws_api_gateway_resource.visit.id
  http_method = aws_api_gateway_method.options.http_method
  type        = "MOCK"
  
  request_templates = {
    "application/json" = "{\"statusCode\": 200}"
  }
}

# OPTIONS response instergration
resource "aws_api_gateway_integration_response" "options_200" {
  rest_api_id = aws_api_gateway_rest_api.this.id
  resource_id = aws_api_gateway_resource.visit.id
  http_method = aws_api_gateway_method.options.http_method
  status_code = "200"
  
  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin"  = "'*'",
    "method.response.header.Access-Control-Allow-Methods" = "'POST,OPTIONS'",
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'"
  }
  
  depends_on = [aws_api_gateway_integration.options]
}