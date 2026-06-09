# get the current aws account ID
data "aws_caller_identity" "current" {}

# ensure that group_names contains all groups the user belongs to
locals {
  group_names = toset(flatten([for user in var.iam_users : user.groups]))
}

resource "aws_iam_group" "groups" {
  for_each = local.group_names
  name     = each.value
}

# create iam users
resource "aws_iam_user" "users" {
  for_each = var.iam_users
  name     = each.key
}

# create user profiles 
resource "aws_iam_user_login_profile" "user_profiles" {
  for_each                = var.create_login_profile ? var.iam_users : {}
  user                    = aws_iam_user.users[each.key].name
  pgp_key                 = var.pgp_key
  password_reset_required = true  # user need to modify password on their first login
}

# group memberships
resource "aws_iam_user_group_membership" "memberships" {
  for_each = var.iam_users
  user     = aws_iam_user.users[each.key].name
  groups   = each.value.groups

  depends_on = [aws_iam_group.groups]
}

resource "aws_iam_group_policy_attachment" "dynamic_attach" {
  for_each   = { for k, v in var.group_policies : k => v if contains(local.group_names, k) }
  group      = aws_iam_group.groups[each.key].name
  policy_arn = each.value
}