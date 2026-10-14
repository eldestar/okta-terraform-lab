variable "environment" {
  description = "Environment name, used as a prefix/tag on created resources."
  type        = string
  default     = "dev"
}

variable "engineering_group_name" {
  description = "Name of the example Engineering group this package creates."
  type        = string
  default     = "Engineering (IaC Lab)"
}

variable "internal_tool_redirect_uri" {
  description = "Redirect URI for the example OAuth app. Replace with a real (or placeholder) URI."
  type        = string
  default     = "https://localhost:8080/callback"
}
