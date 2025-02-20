resource "authentik_provider_ldap" "jellyfin" {
  name            = "Jellyfin (LDAP)"
  base_dn         = "OU=jellyfin,DC=ldap,DC=goauthentik,DC=io"
  bind_mode       = "cached"
  search_mode     = "cached"
  bind_flow       = data.authentik_flow.default-authentication-flow.id
  unbind_flow     = data.authentik_flow.default-invalidation-flow.id
  tls_server_name = "auth.thisratis.gay"
}

resource "authentik_provider_oauth2" "jellyfin" {
  name               = "Jellyfin (OIDC)"
  authorization_flow = data.authentik_flow.default-authorization-flow.id
  invalidation_flow  = data.authentik_flow.default-provider-invalidation-flow.id
  client_id          = var.jellyfinKey
  client_secret      = var.jellyfinSecret
  allowed_redirect_uris = [
    {
      matching_mode = "strict",
      url           = "https://jellyfin.thisratis.gay/sso/OID/redirect/authentik"
    }
  ]
  property_mappings = data.authentik_property_mapping_provider_scope.oauth_scopes.ids
}

data "authentik_property_mapping_provider_scope" "oauth_scopes" {
  managed_list = [
    "goauthentik.io/providers/oauth2/scope-email",
    "goauthentik.io/providers/oauth2/scope-openid",
    "goauthentik.io/providers/oauth2/scope-profile"
  ]
}

resource "authentik_application" "jellyfin" {
  name                  = "Jellyfin"
  group                 = "Streaming"
  slug                  = "jellyfin"
  meta_icon             = "https://raw.githubusercontent.com/loganmarchione/homelab-svg-assets/refs/heads/main/assets/jellyfin.svg"
  meta_launch_url       = "https://jellyfin.thisratis.gay/sso/OID/start/authentik"
  meta_description      = "The Free Software Media System."
  protocol_provider     = authentik_provider_oauth2.jellyfin.id
  backchannel_providers = [authentik_provider_ldap.jellyfin.id]
}

resource "authentik_policy_binding" "jellyfin_user" {
  target = authentik_application.jellyfin.uuid
  group  = authentik_group.discord-user.id
  order  = 0
}

resource "authentik_policy_binding" "jellyfin_allow_ldap" {
  target = authentik_application.jellyfin.uuid
  user   = authentik_user.ldap-search.id
  order  = 0
}
