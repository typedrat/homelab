resource "authentik_provider_oauth2" "open-webui" {
  name               = "Open WebUI (OIDC)"
  authorization_flow = data.authentik_flow.default-authorization-flow.id
  invalidation_flow  = data.authentik_flow.default-provider-invalidation-flow.id
  client_id          = var.openWebUIKey
  client_secret      = var.openWebUISecret
  allowed_redirect_uris = [
    {
      matching_mode = "strict",
      url           = "https://open-webui.thisratis.gay/oauth/oidc/callback"
    }
  ]
  property_mappings = data.authentik_property_mapping_provider_scope.oauth_scopes.ids
}

resource "authentik_application" "open-webui" {
  name              = "open-webui"
  slug              = "open-webui"
  meta_icon         = "https://github.com/open-webui/docs/blob/main/static/images/logo.png?raw=true"
  meta_launch_url   = "https://open-webui.thisratis.gay/"
  meta_description  = <<-DESC
    Open WebUI is an extensible, feature-rich, and user-friendly self-hosted AI platform designed to operate entirely offline.

    It supports various LLM runners like Ollama and OpenAI-compatible APIs, with built-in inference engine for RAG, making it a powerful AI deployment solution.
  DESC
  protocol_provider = authentik_provider_oauth2.open-webui.id
}
