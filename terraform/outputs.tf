output "engineering_group_id" {
  value       = module.groups.engineering_group_id
  description = "Okta ID of the example Engineering group."
}

output "internal_tool_app_id" {
  value       = module.apps.internal_tool_app_id
  description = "Okta ID of the example OAuth app."
}
