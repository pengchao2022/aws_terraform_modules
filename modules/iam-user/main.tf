# dynamicly create IAM group using set to remove duplicated
locals {
  group_names = toset([for user in var.var.iam_users : u.group])

}

resource "aws_iam_group" "group" {
  for_each = local.group_names
  name     = each.value
  
}

# create multiple IAM users
resource "aws_iam_user" "users" {
  for_each = var.iam_users
  name     = each.key
  
}

# create multiple console login profile configration only create_login_profile is true
resource "aws_iam_user_login_profile" "user_profiles" {
  for_each                = var.create_login_profile ? var.iam_users : {}
  user                    = aws_iam_user.users[each.key].name
  pgp_key                 = var.pgp_key
  password_reset_required = true
  
}

# multiple added users to groups
resource "aws_iam_user_group_membership" "memberships" {
  for_each    = var.iam_users
  user        = aws_iam_user.users[each.key].name
  groups      = [each.value.group]
}

# multiple create access password
resource "aws_iam_access_key" "user_keys" {
  for_each = var.iam_users
  user     = aws_iam_user.users[each.key].name
  
}

# bind with permissions
resource "aws_iam_group_policy_attachment" "dynamic_attach" {
  for_each = var.group_policies

  group    = aws_iam_group.groups[each.key].name
  policy_arn = each.value
      
}