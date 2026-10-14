# Root module -- wires together the child modules. Keep resource declarations
# themselves inside modules/*, so this file stays a readable table of contents.

module "groups" {
  source = "./modules/groups"

  environment = var.environment
  group_name  = var.engineering_group_name
}

module "apps" {
  source = "./modules/apps"

  environment          = var.environment
  redirect_uri         = var.internal_tool_redirect_uri
  engineering_group_id = module.groups.engineering_group_id
}

module "policies" {
  source = "./modules/policies"

  environment          = var.environment
  engineering_group_id = module.groups.engineering_group_id
}
