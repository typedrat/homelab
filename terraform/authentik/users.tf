resource "authentik_user" "ldap-search" {
  username = var.ldapUsername
  password = var.ldapPassword
  type     = "service_account"
}

# resource "authentik_rbac_permission_user" "ldap-search-users" {
#   user       = authentik_user.ldap-search.id
#   permission = "authentik_provider_ldap.search_full_directory"
# }
