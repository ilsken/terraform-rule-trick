variable "flag_variations" {
  type = map(number)
  description = "mapping of flag key -> variation"
}

variable "add_pr" {
  type = string
  description = "Pull Request name/label"
}

variable "project_key" {
  type = string
  description = "LaunchDarkly Project Key"
}

variable "env_key" {
  type = string
  description = "LaunchDarkly Project Key"
}






module "pr_rules_flag" {
  for_each = var.flag_variations
  source = "../flag-pr"
  project_key = var.project_key
  env_key = var.env_key
  flag_key = each.key
  prs = { (var.add_pr) = each.value }
}
