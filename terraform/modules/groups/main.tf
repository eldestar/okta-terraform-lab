resource "okta_group" "engineering" {
  name        = var.group_name
  description = "Example group created by the okta-terraform-lab (${var.environment})."
}

resource "okta_group_rule" "auto_engineering" {
  name              = "auto-assign-${lower(replace(var.group_name, " ", "-"))}"
  status            = "ACTIVE"
  group_assignments = [okta_group.engineering.id]
  expression_type   = "urn:okta:expression:1.0"
  expression_value  = "user.department==\"Engineering\""
}
