# aws console login url
output "aws_console_login_url" {
  description = "The URL for IAM user to login aws console"
  value       = "https://${data.aws_caller_identity.current.account_id}.signin.aws.amazon.com/console"
}

# aws_account_id e.g. "317429619308"
output "aws_account_id" {
  description = "The AWS login Account ID"
  value       = data.aws_caller_identity.current.account_id
}

# user login credentials info
output "iam_users_login_info" {
  description = "IAM uesrs credentials when login aws console"
  sensitive   = true 
  value = {
    for name, user in aws_iam_user.users : name => {
      username           = name
      encrypted_password = var.create_login_profile ? aws_iam_user_login_profile.user_profiles[name].encrypted_password : "Not created"
      user_arn           = user.arn
    }
  }
}