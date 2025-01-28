data "authentik_flow" "default-source-authentication" {
  slug = "default-source-authentication"
}

resource "authentik_policy_expression" "discord-auth-policy" {
  name = "discord-auth-policy"
  expression = templatefile("${path.module}/policy_discord_auth.py", {
    guildId   = var.guildId
    guildName = var.guildName
  })
}

resource "authentik_policy_binding" "discord-auth-policy-binding" {
  target = data.authentik_flow.default-source-authentication.id
  policy = authentik_policy_expression.discord-auth-policy.id
  order  = 0
}
