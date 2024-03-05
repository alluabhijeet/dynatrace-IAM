variable "product_teams" {
  description = "List of product teams with permissions and management zones"
  type = list(object({
    name           : string
    ManagementZone : list(string)
  }))
}

variable "platform_teams" {
  description = "List of platform teams with permissions and management zones"
  type = list(object({
    name           : string
    ManagementZone : list(string)
  }))
}

variable "environment" {
  type    = string
  description = "URL of the environment"
}

variable "product_teams_permissions" {
  type = object({
    globalPermissions        = string
    ManagementZonePermissions = string
  })
}

variable "platform_teams_permissions" {
  type = object({
    globalPermissions        = string
    ManagementZonePermissions = string
  })
}

resource "dynatrace_iam_policy" "product_policy" {
  for_each        = { for team in var.product_teams : team.name => team }
  name            = each.key
  environment     = var.environment
  statement_query = "${var.product_teams_permissions.globalPermissions}; ${var.product_teams_permissions.ManagementZonePermissions} WHERE environment:management-zone IN (\"${join("\", \"", each.value.ManagementZone)}\");"
}

resource "dynatrace_iam_policy" "platform_policy" {
  for_each        = { for team in var.platform_teams : team.name => team }
  name            = each.key
  environment     = var.environment
  statement_query = "${var.platform_teams_permissions.globalPermissions}; ${var.platform_teams_permissions.ManagementZonePermissions} WHERE environment:management-zone IN (\"${join("\", \"", each.value.ManagementZone)}\");"
}

resource "dynatrace_iam_group" "product_group" {
  for_each = { for team in var.product_teams : team.name => team }
  name     = each.key
}

resource "dynatrace_iam_group" "platform_group" {
  for_each = { for team in var.platform_teams : team.name => team }
  name     = each.key
}

resource "dynatrace_iam_policy_bindings" "product_bindings" {
  for_each    = { for team in var.product_teams : team.name => team }
  group       = dynatrace_iam_group.product_group[each.key].id
  environment = var.environment
  policies    = [dynatrace_iam_policy.product_policy[each.key].id]
}

resource "dynatrace_iam_policy_bindings" "platform_bindings" {
  for_each    = { for team in var.platform_teams : team.name => team }
  group       = dynatrace_iam_group.platform_group[each.key].id
  environment = var.environment
  policies    = [dynatrace_iam_policy.platform_policy[each.key].id]
}
