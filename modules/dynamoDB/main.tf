resource "aws_dynamodb_table" "this" {
  name = var.table_name
  billing_mode = "PAY_PER_REQUEST" # cost on-demand
  hash_key = "user"                # primary key

  attribute {
    name = "user"
    type = "S"                     # string 
  }
}