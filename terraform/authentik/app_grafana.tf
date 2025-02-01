resource "authentik_provider_oauth2" "grafana" {
  name               = "Grafana (OIDC)"
  authorization_flow = data.authentik_flow.default-authorization-flow.id
  invalidation_flow  = data.authentik_flow.default-provider-invalidation-flow.id
  client_id          = var.grafanaKey
  client_secret      = var.grafanaSecret
  allowed_redirect_uris = [
    {
      matching_mode = "strict",
      url           = "https://grafana.thisratis.gay/login/generic_oauth"
    }
  ]
  property_mappings = data.authentik_property_mapping_provider_scope.oauth_scopes.ids
}

resource "authentik_application" "grafana" {
  name              = "Grafana"
  group             = "System"
  slug              = "grafana"
  meta_icon         = "https://raw.githubusercontent.com/loganmarchione/homelab-svg-assets/refs/heads/main/assets/grafana.svg"
  meta_launch_url   = "https://grafana.thisratis.gay/"
  meta_description  = "The Free Software Media System."
  protocol_provider = authentik_provider_oauth2.grafana.id
}

resource "authentik_policy_binding" "grafana_sysop" {
  target = authentik_application.grafana.uuid
  group  = authentik_group.discord-sysop.id
  order  = 0
}
