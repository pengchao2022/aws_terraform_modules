output "console_login_url" {
  description = "the URL for IAM user to login the aws console"
  value = "https://${data.aws_caller_identity.current.account_id}.signin.aws.amazon.com/console"
  
}

output "username" {
  description = "The name of IAM user"
  value = aws_iam_user.user.name

}

output "user_arn" {
  description = "the arn of the IAM user"
  value = aws_iam_user.user.arn
  
}

output "access_key_id" {
  description = "IAM user access Key ID"
  value = aws_iam_access_key.user_key.id  
}

output "secret_access_key" {
  description = "IAM secret access key (sensitive info)"
  value = aws_iam_access_key.user_key.secret
  sensitive = true
}

output "encrypted_password" {
  description = "Encrypted initial password used PGP private key"
  value = var.create_login_profile ? aws_iam_user_login_profile.user_profile[0].encrypted_password : "Not created"
  sensitive = true
}

