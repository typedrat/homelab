resource "authentik_flow" "discord_enrollment" {
  name        = "Welcome to authentik! Please complete your registration."
  title       = "Welcome to authentik! Please complete your registration."
  slug        = "discord-enrollment"
  designation = "enrollment"
}


resource "authentik_policy_binding" "discord_enrollment_bind_sso_only" {
  target = authentik_flow.discord_enrollment.uuid
  policy = authentik_policy_expression.sso_only.id
  order  = 0
}

resource "authentik_flow_stage_binding" "discord_enrollment_bind_password_setup" {
  target = authentik_flow.discord_enrollment.uuid
  stage  = authentik_stage_prompt.password_setup.id
  order  = 0
}

resource "authentik_policy_expression" "discord_enrollment" {
  name = "discord_enrollment"
  expression = templatefile("${path.module}/policy_discord_enrollment.py", {
    guildId   = var.guildId
    guildName = var.guildName
  })
}

resource "authentik_policy_binding" "policy_discord_enrollment_binding" {
  target = authentik_flow_stage_binding.discord_enrollment_bind_password_setup.id
  policy = authentik_policy_expression.discord_enrollment.id
  order  = 0
}

resource "authentik_stage_user_write" "discord_enrollment_write" {
  name                     = "discord_enrollment_write"
  user_creation_mode       = "always_create"
  create_users_as_inactive = false
}

resource "authentik_flow_stage_binding" "discord_enrollment_bind_write" {
  target = authentik_flow.discord_enrollment.uuid
  stage  = authentik_stage_user_write.discord_enrollment_write.id
  order  = 5
}

resource "authentik_stage_user_login" "discord_enrollment_login" {
  name = "discord_enrollment_login"
}

resource "authentik_flow_stage_binding" "discord_enrollment_bind_login" {
  target = authentik_flow.discord_enrollment.uuid
  stage  = authentik_stage_user_login.discord_enrollment_login.id
  order  = 10
}
