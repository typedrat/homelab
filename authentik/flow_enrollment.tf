data "authentik_flow" "default-source-enrollment" {
  slug = "default-source-enrollment"
}

resource "authentik_policy_expression" "discord-enrollment-policy" {
  name = "discord-enrollment-policy"
  expression = templatefile("${path.module}/policy_discord_enrollment.py", {
    guildId   = var.guildId
    guildName = var.guildName
  })
}

resource "authentik_policy_binding" "discord-enrollment-policy-binding" {
  target = data.authentik_flow.default-source-enrollment.id
  policy = authentik_policy_expression.discord-enrollment-policy.id
  order  = 0
}

resource "authentik_flow_stage_binding" "enrollment_flow_set_password" {
  target = data.authentik_flow.default-source-enrollment.id
  stage  = authentik_stage_prompt.password_setup.id
  order  = 10
}
