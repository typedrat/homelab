resource "authentik_flow" "password_setup" {
  name        = "Password Setup Flow"
  title       = "Set Up Password"
  slug        = "password-setup"
  designation = "stage"
}

resource "authentik_stage_prompt" "password_setup" {
  name = "Password Setup Stage"
  fields = jsonencode([
    {
      "field_key" : "password",
      "label" : "Password",
      "type" : "password",
      "required" : true,
      "placeholder" : "Enter your new password"
    },
    {
      "field_key" : "password-repeat",
      "label" : "Confirm Password",
      "type" : "password",
      "required" : true,
      "placeholder" : "Confirm your new password"
    }
  ])
}

resource "authentik_flow_stage_binding" "password_setup_binding" {
  target = authentik_flow.password_setup.uuid
  stage  = authentik_stage_prompt.password_setup.id
  order  = 0
}

resource "authentik_stage_flow_decision" "password_decision" {
  name          = "Password Setup Decision"
  flow_on_match = authentik_flow.password_setup.uuid
}

resource "authentik_policy_binding" "password_check_binding" {
  target = authentik_stage_flow_decision.password_decision.id
  policy = authentik_policy_expression.password_check.id
  order  = 0
}
