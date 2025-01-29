data "authentik_flow" "default-authorization-flow" {
  slug = "default-provider-authorization-implicit-consent"
}

data "authentik_flow" "default-provider-invalidation-flow" {
  slug = "default-provider-invalidation-flow"
}

resource "authentik_provider_proxy" "prowlarr" {
  name               = "Prowlarr"
  external_host      = "https://prowlarr.thisratis.gay"
  mode               = "forward_single"
  authorization_flow = data.authentik_flow.default-authorization-flow.id
  invalidation_flow  = data.authentik_flow.default-provider-invalidation-flow.id
}

resource "authentik_application" "prowlarr" {
  name              = "Prowlarr"
  slug              = "prowlarr"
  meta_icon         = "https://raw.githubusercontent.com/Prowlarr/Prowlarr/refs/heads/develop/Logo/Prowlarr.svg"
  protocol_provider = authentik_provider_proxy.prowlarr.id
}
