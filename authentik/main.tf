resource "authentik_source_oauth" "discord" {
  name                = "Discord"
  slug                = "discord"
  authentication_flow = authentik_flow.discord_auth.id
  enrollment_flow     = authentik_flow.discord_enrollment.id

  provider_type     = "discord"
  consumer_key      = var.discordKey
  consumer_secret   = var.discordSecret
  additional_scopes = "guilds guilds.members.read"
}
