############################################
# Phase 1: Azure AD Groups
############################################
# Terraform is the OWNER of these groups
resource "azuread_group" "groups" {
  for_each         = toset(var.aad_groups)
  display_name     = each.key
  security_enabled = true
}

############################################
# Phase 2: Users via YAML config
############################################

# Read and process YAML user config
locals {
  user_config = yamldecode(
    file("${path.module}/../../config/azure-users.yaml")
  )

  # Flatten users and groups into pairs
  users = flatten([
    for user in local.user_config.users : [
      for group in user.groups : {
        email = user.email
        group = group
      }
    ]
  ])
}

############################################
# Lookup Azure AD users (must already exist)
############################################
data "azuread_user" "users" {
  for_each = {
    for u in local.users : u.email => u
  }

  user_principal_name = each.key
}

############################################
# Add users to groups (created by Terraform)
############################################
resource "azuread_group_member" "membership" {
  for_each = {
    for u in local.users :
    "${u.email}-${u.group}" => u
  }

  # IMPORTANT:
  # Reference the RESOURCE, not a data source
  group_object_id  = azuread_group.groups[each.value.group].id
  member_object_id = data.azuread_user.users[each.value.email].id
}
