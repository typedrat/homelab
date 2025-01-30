resource "authentik_provider_proxy" "flood" {
  name                  = "Flood"
  external_host         = "https://flood.thisratis.gay"
  mode                  = "forward_single"
  access_token_validity = "days=1"
  authorization_flow    = data.authentik_flow.default-authorization-flow.id
  invalidation_flow     = data.authentik_flow.default-provider-invalidation-flow.id
}

resource "authentik_application" "flood" {
  name              = "Flood"
  group             = "Torrents"
  slug              = "flood"
  meta_icon         = "https://raw.githubusercontent.com/jesec/flood/master/flood.svg"
  meta_description  = "A modern web UI for various torrent clients."
  protocol_provider = authentik_provider_proxy.flood.id
}

resource "authentik_policy_binding" "flood_sysop" {
  target = authentik_application.flood.uuid
  group  = authentik_group.discord-sysop.id
  order  = 0
}
