resource "authentik_provider_proxy" "radarr" {
  name                  = "Radarr"
  external_host         = "https://radarr.thisratis.gay"
  mode                  = "forward_single"
  access_token_validity = "days=1"
  authorization_flow    = data.authentik_flow.default-authorization-flow.id
  invalidation_flow     = data.authentik_flow.default-provider-invalidation-flow.id
}

resource "authentik_application" "radarr" {
  name              = "Radarr"
  slug              = "radarr"
  group             = "Torrents"
  meta_icon         = "https://raw.githubusercontent.com/Radarr/Radarr/refs/heads/develop/Logo/Radarr.svg"
  meta_description  = "Movie organizer/manager for usenet and torrent users."
  protocol_provider = authentik_provider_proxy.radarr.id
}

resource "authentik_policy_binding" "radarr_sysop" {
  target = authentik_application.radarr.uuid
  group  = authentik_group.discord-sysop.id
  order  = 0
}
