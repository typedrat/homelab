data "authentik_flow" "default-authorization-flow" {
  slug = "default-provider-authorization-implicit-consent"
}

data "authentik_flow" "default-provider-invalidation-flow" {
  slug = "default-provider-invalidation-flow"
}

resource "authentik_provider_proxy" "radarr" {
  name               = "Radarr"
  external_host      = "https://radarr.thisratis.gay"
  mode               = "forward_single"
  authorization_flow = data.authentik_flow.default-authorization-flow.id
  invalidation_flow  = data.authentik_flow.default-provider-invalidation-flow.id
}

resource "authentik_application" "radarr" {
  name              = "Radarr"
  slug              = "radarr"
  meta_icon         = "https://raw.githubusercontent.com/Radarr/Radarr/refs/heads/develop/Logo/Radarr.svg"
  protocol_provider = authentik_provider_proxy.radarr.id
}
