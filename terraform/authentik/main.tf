resource "authentik_source_oauth" "discord" {
  name                = "Discord"
  slug                = "discord"
  authentication_flow = authentik_flow.discord_auth.uuid
  enrollment_flow     = authentik_flow.discord_enrollment.uuid

  provider_type     = "discord"
  consumer_key      = var.discordKey
  consumer_secret   = var.discordSecret
  additional_scopes = "guilds guilds.members.read"
}
