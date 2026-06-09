# 1. 统一输出 AWS 登录所需的 URL
output "aws_console_login_url" {
  description = "IAM 用户登录控制台的标准 URL"
  value       = "https://${data.aws_caller_identity.current.account_id}.signin.aws.amazon.com/console"
}

# 2. 输出 Account ID (截图里的第一项)
output "aws_account_id" {
  description = "用于 AWS 登录的 Account ID"
  value       = data.aws_caller_identity.current.account_id
}

# 3. 仅输出用户登录凭证 (不包含 Secret Access Key)
output "iam_users_login_info" {
  description = "IAM 用户登录控制台的标准凭证"
  sensitive   = true 
  value = {
    for name, user in aws_iam_user.users : name => {
      username           = name
      encrypted_password = var.create_login_profile ? aws_iam_user_login_profile.user_profiles[name].encrypted_password : "Not created"
      user_arn           = user.arn
    }
  }
}