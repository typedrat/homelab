resource "authentik_source_oauth" "discord" {
  name                = "Discord"
  slug                = "discord"
  authentication_flow = data.authentik_flow.default-source-authentication.id
  enrollment_flow     = data.authentik_flow.default-source-enrollment.id

  provider_type     = "discord"
  consumer_key      = var.discordKey
  consumer_secret   = var.discordSecret
  additional_scopes = "guilds guilds.members.read"
}
