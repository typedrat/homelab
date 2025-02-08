resource "authentik_provider_ldap" "sftpgo" {
  name            = "SFTPGo (LDAP)"
  base_dn         = "OU=sftpgo,DC=ldap,DC=goauthentik,DC=io"
  bind_flow       = data.authentik_flow.default-authentication-flow.id
  unbind_flow     = data.authentik_flow.default-invalidation-flow.id
  tls_server_name = "auth.thisratis.gay"
}

resource "authentik_provider_oauth2" "sftpgo" {
  name               = "SFTPGo (OIDC)"
  authorization_flow = data.authentik_flow.default-authorization-flow.id
  invalidation_flow  = data.authentik_flow.default-provider-invalidation-flow.id
  client_id          = var.sftpgoKey
  client_secret      = var.sftpgoSecret
  allowed_redirect_uris = [
    {
      matching_mode = "strict",
      url           = "https://sftpgo.thisratis.gay/web/oidc/redirect"
    }
  ]
  property_mappings = data.authentik_property_mapping_provider_scope.oauth_scopes.ids
}

resource "authentik_application" "sftpgo" {
  name                  = "SFTPGo"
  group                 = "System"
  slug                  = "sftpgo"
  meta_icon             = "https://raw.githubusercontent.com/drakkan/sftpgo/refs/heads/main/img/logo.png"
  meta_launch_url       = "https://sftpgo.thisratis.gay/web/client"
  meta_description      = "Full-featured and highly configurable SFTP, HTTP/S, FTP/S and WebDAV server."
  protocol_provider     = authentik_provider_oauth2.sftpgo.id
  backchannel_providers = [authentik_provider_ldap.sftpgo.id]
}

resource "authentik_policy_binding" "sftpgo_user" {
  target = authentik_application.sftpgo.uuid
  group  = authentik_group.discord-user.id
  order  = 0
}

resource "authentik_policy_binding" "sftpgo_allow_ldap" {
  target = authentik_application.sftpgo.uuid
  user   = authentik_user.ldap-search.id
  order  = 0
}
