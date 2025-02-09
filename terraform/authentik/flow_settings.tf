resource "authentik_flow" "user-settings" {
  name           = "User settings"
  title          = "Update your info"
  designation    = "stage_configuration"
  slug           = "user-settings"
  authentication = "require_authenticated"
}

resource "authentik_stage_prompt" "user-settings-prompt" {
  name = "User Settings Prompt"
  fields = [
    authentik_stage_prompt_field.user-settings-prompt-username.id,
    authentik_stage_prompt_field.user-settings-prompt-name.id,
    authentik_stage_prompt_field.user-settings-prompt-email.id,
    authentik_stage_prompt_field.user-settings-prompt-locale.id,
    authentik_stage_prompt_field.user-settings-prompt-ssh-keys.id,
  ]
}

resource "authentik_stage_prompt_field" "user-settings-prompt-username" {
  name      = "user-settings-prompt-username"
  label     = "Username"
  type      = "username"
  field_key = "username"
  order     = 0
}

resource "authentik_stage_prompt_field" "user-settings-prompt-name" {
  name      = "user-settings-prompt-name"
  label     = "Name"
  type      = "text"
  field_key = "name"
  order     = 10
}

resource "authentik_stage_prompt_field" "user-settings-prompt-email" {
  name      = "user-settings-prompt-email"
  label     = "Email"
  type      = "email"
  field_key = "email"
  order     = 20
}

resource "authentik_stage_prompt_field" "user-settings-prompt-locale" {
  name      = "user-settings-prompt-locale"
  label     = "Locale"
  type      = "ak-locale"
  field_key = "attributes.settings.locale"
  order     = 30
}

resource "authentik_stage_prompt_field" "user-settings-prompt-ssh-keys" {
  name      = "user-settings-prompt-ssh-keys"
  label     = "SSH Keys"
  type      = "text_area"
  field_key = "attributes.sshPublicKey"
  sub_text  = <<-HELP
  Enter the SSH public keys associated with your account in OpenSSH format, one per line.
  HELP
  order     = 40
}

resource "authentik_flow_stage_binding" "user-settings-prompt-binding" {
  target = authentik_flow.user-settings.uuid
  stage  = authentik_stage_prompt.user-settings-prompt.id
  order  = 0
}

resource "authentik_stage_user_write" "user-settings-write" {
  name = "User Settings Write"
}

resource "authentik_flow_stage_binding" "user-settings-write-binding" {
  target           = authentik_flow.user-settings.uuid
  stage            = authentik_stage_user_write.user-settings-write.id
  order            = 10
  evaluate_on_plan = false
}

resource "authentik_policy_expression" "user-settings-ssh-key-list" {
  name       = "user-settings-ssh-key-list"
  expression = <<-PYTHON
  prompt_data = context['prompt_data']['attributes']['sshPublicKey']

  sshKeyList = prompt_data.split("\n")
  context['prompt_data']['attributes']['sshPublicKey'] = sshKeyList

  return True
  PYTHON
}

resource "authentik_policy_binding" "user-settings-write-binding" {
  target = authentik_flow_stage_binding.user-settings-write-binding.id
  policy = authentik_policy_expression.user-settings-ssh-key-list.id
  order  = 0
}
