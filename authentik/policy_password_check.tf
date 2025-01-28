resource "authentik_policy_expression" "password_check" {
  name       = "Check User Has Password"
  expression = "return user.has_usable_password()"
}
