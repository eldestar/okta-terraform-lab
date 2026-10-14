resource "okta_policy_signon" "require_strong_auth" {
  name            = "Require strong auth (IaC Lab, ${var.environment})"
  status          = "ACTIVE"
  description     = "Example sign-on policy created by the okta-terraform-lab."
  groups_included = [var.engineering_group_id]
}

resource "okta_policy_rule_signon" "require_strong_auth_default" {
  policy_id    = okta_policy_signon.require_strong_auth.id
  name         = "default"
  status       = "ACTIVE"
  mfa_required = true
}
