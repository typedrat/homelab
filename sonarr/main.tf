data "authentik_flow" "default-authorization-flow" {
  slug = "default-provider-authorization-implicit-consent"
}

data "authentik_flow" "default-provider-invalidation-flow" {
  slug = "default-provider-invalidation-flow"
}

resource "authentik_provider_proxy" "sonarr" {
  name               = "Sonarr"
  external_host      = "https://sonarr.thisratis.gay"
  mode               = "forward_single"
  authorization_flow = data.authentik_flow.default-authorization-flow.id
  invalidation_flow  = data.authentik_flow.default-provider-invalidation-flow.id
}

resource "authentik_application" "sonarr" {
  name              = "Sonarr"
  slug              = "sonarr"
  meta_icon         = "https://raw.githubusercontent.com/Sonarr/Sonarr/refs/heads/develop/Logo/Sonarr.svg"
  protocol_provider = authentik_provider_proxy.sonarr.id
}
