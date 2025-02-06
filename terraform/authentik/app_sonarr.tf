resource "authentik_provider_proxy" "sonarr" {
  name                  = "Sonarr"
  external_host         = "https://sonarr.thisratis.gay"
  mode                  = "forward_single"
  access_token_validity = "days=1"
  authorization_flow    = data.authentik_flow.default-authorization-flow.id
  invalidation_flow     = data.authentik_flow.default-provider-invalidation-flow.id
}

resource "authentik_application" "sonarr" {
  name              = "Sonarr"
  slug              = "sonarr"
  group             = "Torrents"
  meta_icon         = "https://raw.githubusercontent.com/Sonarr/Sonarr/refs/heads/develop/Logo/Sonarr.svg"
  meta_description  = "Sonarr is an internet PVR for Usenet and Torrents."
  protocol_provider = authentik_provider_proxy.sonarr.id
}

resource "authentik_policy_binding" "sonarr_sysop" {
  target = authentik_application.sonarr.uuid
  group  = authentik_group.discord-sysop.id
  order  = 0
}

resource "authentik_provider_proxy" "sonarr-anime" {
  name                  = "Sonarr (Anime)"
  external_host         = "https://sonarr-anime.thisratis.gay"
  mode                  = "forward_single"
  access_token_validity = "days=1"
  authorization_flow    = data.authentik_flow.default-authorization-flow.id
  invalidation_flow     = data.authentik_flow.default-provider-invalidation-flow.id
}

resource "authentik_application" "sonarr-anime" {
  name              = "Sonarr (Anime)"
  slug              = "sonarr-anime"
  group             = "Torrents"
  meta_icon         = "https://raw.githubusercontent.com/Sonarr/Sonarr/refs/heads/develop/Logo/Sonarr.svg"
  meta_description  = "Sonarr is an internet PVR for Usenet and Torrents."
  protocol_provider = authentik_provider_proxy.sonarr-anime.id
}

resource "authentik_policy_binding" "sonarr-anime_sysop" {
  target = authentik_application.sonarr-anime.uuid
  group  = authentik_group.discord-sysop.id
  order  = 0
}
