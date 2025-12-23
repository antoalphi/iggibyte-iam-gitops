resource "azuread_group" "groups" {
  for_each         = toset(var.aad_groups)
  display_name     = each.key
  security_enabled = true
}
