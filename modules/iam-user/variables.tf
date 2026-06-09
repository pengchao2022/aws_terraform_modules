variable "iam_users" {
  description = "IAM users list and groups belonged {username = { group = 'group_name' }}"
  type        = map(object({
    group = string
  }))

  # structure examples:
  # {
  #   "alice" = { group = "devops" }
  #   "bob"   = { group = "devs" }
  #   "sean"  = { group = "sre" }
  # }
}

variable "group_policies" {
  description = "define the group name map with the policy ARN"
  type        = map(string)
  default = {
    "devops"     = "arn:aws:iam::aws:policy/AdministratorAccess"
    "devs"       = "arn:aws:iam::aws:policy/PowerUserAccess"
    "sre"        = "arn:aws:iam::aws:policy/PowerUserAccess"
    "readonly"   = "arn:aws:iam::aws:policy/ReadOnlyAccess"
  }
  
}
  
variable "pgp_key" {
  description = "The PGP public key or keybase:username used to encrypt the console password"
  type        = string
}

variable "create_login_profile" {
  description = "Whether create console login for this user"
  type        = bool
}

