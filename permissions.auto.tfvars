#IAM Reference for Permissions : https://docs.dynatrace.com/docs/shortlink/iam-policystatements

/* 
Permissions that will be granted for all Product Teams
Global Permissions are permissions that will be granted at an environment level
ManagementZonePermissions are permissions that will be scoped to ManagementZones
*/
product_teams_permissions = {
  globalPermissions        = "ALLOW davis-copilot:conversations"
  ManagementZonePermissions = "ALLOW settings:objects:read"
}

/* 
Permissions that will be granted for all Platform Teams
Global Permissions are permissions that will be granted at an environment level
ManagementZonePermissions are permissions that will be scoped to ManagementZones
*/
platform_teams_permissions = {
  globalPermissions        = "ALLOW davis-copilot:conversations"
  ManagementZonePermissions = "ALLOW environment:roles:manage-settings"
}