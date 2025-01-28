data "authentik_flow" "default-authorization-flow" {
  slug = "default-provider-authorization-implicit-consent"
}

data "authentik_flow" "default-provider-invalidation-flow" {
  slug = "default-provider-invalidation-flow"
}

resource "authentik_provider_proxy" "name" {
  name               = "Flood"
  external_host      = "https://flood.thisratis.gay"
  mode               = "forward_single"
  authorization_flow = data.authentik_flow.default-authorization-flow.id
  invalidation_flow  = data.authentik_flow.default-provider-invalidation-flow.id
}

resource "authentik_application" "name" {
  name              = "Flood"
  slug              = "flood"
  meta_icon         = "https://raw.githubusercontent.com/jesec/flood/master/flood.svg"
  protocol_provider = authentik_provider_proxy.name.id
}
