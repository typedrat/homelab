resource "authentik_policy_expression" "sso_only" {
  name       = "sso_only"
  expression = <<-PYTHON
  return ak_is_sso_flow
  PYTHON
}
