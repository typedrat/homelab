resource "authentik_policy_expression" "password_check" {
  name          = "Check User Has Password"
  expression    = "return not user.has_usable_password()"
  pass_on_false = true # Pass when user HAS a password
}
