resource "authentik_flow" "discord_auth" {
  name           = "Authenticate with Discord"
  title          = "Authenticate with Discord"
  slug           = "discord-auth"
  designation    = "authentication"
  authentication = "require_unauthenticated"
}

resource "authentik_policy_binding" "discord_auth_bind_sso_only" {
  target = authentik_flow.discord_auth.id
  policy = authentik_policy_expression.sso_only.id
  order  = 0
}

resource "authentik_stage_user_login" "discord_auth_login" {
  name = "discord_auth_login"
}

resource "authentik_flow_stage_binding" "discord_auth_bind_login" {
  target = authentik_flow.discord_auth.id
  stage  = authentik_stage_user_login.discord_auth_login.id
  order  = 0
}

resource "authentik_policy_expression" "discord_auth" {
  name = "discord_auth"
  expression = templatefile("${path.module}/policy_discord_auth.py", {
    guildId   = var.guildId
    guildName = var.guildName
  })
}

resource "authentik_policy_binding" "discord_auth_bind_policy" {
  target = authentik_stage_user_login.discord_auth_login.id
  policy = authentik_policy_expression.discord_auth.id
  order  = 0
}
