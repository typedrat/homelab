resource "authentik_stage_prompt" "password_setup" {
  name = "Password Setup Stage"
  fields = [
    authentik_stage_prompt_field.password.id,
    authentik_stage_prompt_field.password_repeat.id,
  ]
  validation_policies = [
    authentik_policy_password.password_strong.id
  ]
}

resource "authentik_stage_prompt_field" "password" {
    name      = "password_setup_password"
    field_key = "password"
    label     = "Password"
    type      = "password"
    required  = true
    placeholder = "Enter your new password"
}

resource "authentik_stage_prompt_field" "password_repeat" {
    name      = "password_setup_password_repeat"
    field_key = "password_repeat"
    label     = "Confirm Password"
    type      = "password"
    required  = true
    placeholder = "Confirm your new password"
}
