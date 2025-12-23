############################################
# Phase 1: Azure AD Groups (unchanged)
############################################
resource "azuread_group" "groups" {
  for_each         = toset(var.aad_groups)
  display_name     = each.key
  security_enabled = true
}

############################################
# Phase 2: Users via YAML config
############################################

# 1. Read YAML file
locals {
  user_config = yamldecode(
    file("${path.module}/../../config/azure-users.yaml")
  )

  # 2. Flatten users and groups
  users = flatten([
    for user in local.user_config.users : [
      for group in user.groups : {
        email = user.email
        group = group
      }
    ]
  ]

# Lookup Azure AD users
data "azuread_user" "users" {
  for_each = {
    for u in local.users : u.email => u
  }

  user_principal_name = each.key
}

# Lookup existing Azure AD groups
data "azuread_group" "existing_groups" {
  for_each = toset([
    for u in local.users : u.group
  ])

  display_name = each.key
}

# Add users to groups
resource "azuread_group_member" "membership" {
  for_each = {
    for u in local.users :
    "${u.email}-${u.group}" => u
  }

  group_object_id  = data.azuread_group.existing_groups[each.value.group].id
  member_object_id = data.azuread_user.users[each.value.email].id
}
