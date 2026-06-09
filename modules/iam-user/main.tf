# 1. Identity
data "aws_caller_identity" "current" {}

# 2. 组逻辑：确保 group_names 包含所有用户所属组
locals {
  group_names = toset([for user in var.iam_users : user.group])
}

resource "aws_iam_group" "groups" {
  for_each = local.group_names
  name     = each.value
}

# 3. 用户逻辑
resource "aws_iam_user" "users" {
  for_each = var.iam_users
  name     = each.key
}

# 4. 登录资料：修复后的三元运算符写法
resource "aws_iam_user_login_profile" "user_profiles" {
  for_each                = var.create_login_profile ? var.iam_users : {}
  user                    = aws_iam_user.users[each.key].name
  pgp_key                 = var.pgp_key
  password_reset_required = true
}

# 5. 组成员关系
resource "aws_iam_user_group_membership" "memberships" {
  for_each = var.iam_users
  user     = aws_iam_user.users[each.key].name
  groups   = [each.value.group]
  
  # 显式声明依赖，防止资源创建顺序冲突
  depends_on = [aws_iam_group.groups]
}

# 6. 密钥
resource "aws_iam_access_key" "user_keys" {
  for_each = var.iam_users
  user     = aws_iam_user.users[each.key].name
}

# 7. 策略绑定：增加判断，防止 Key 不匹配
resource "aws_iam_group_policy_attachment" "dynamic_attach" {
  for_each   = { for k, v in var.group_policies : k => v if contains(local.group_names, k) }
  group      = aws_iam_group.groups[each.key].name
  policy_arn = each.value
}