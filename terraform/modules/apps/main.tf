resource "okta_app_oauth" "internal_tool" {
  label                      = "IaC Lab Internal Tool (${var.environment})"
  type                       = "web"
  grant_types                = ["authorization_code"]
  redirect_uris              = [var.redirect_uri]
  response_types             = ["code"]
  token_endpoint_auth_method = "client_secret_basic"
  consent_method             = "REQUIRED"
}

resource "okta_app_group_assignment" "internal_tool_engineering" {
  app_id   = okta_app_oauth.internal_tool.id
  group_id = var.engineering_group_id
}
