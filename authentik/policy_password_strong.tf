resource "authentik_policy_password" "password_strong" {
  name                   = "password_strong"
  length_min             = 8
  error_message          = "Password needs to be 8 characters or longer."
  check_zxcvbn           = true
  zxcvbn_score_threshold = 2
}
