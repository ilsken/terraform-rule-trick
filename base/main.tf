# Configure the LaunchDarkly provider
provider "launchdarkly" {
  access_token = var.launchdarkly_access_token
}

terraform {
  required_providers {
    launchdarkly = {
      # The "hashicorp" namespace is the new home for the HashiCorp-maintained
      # provider plugins.
      #
      # source is not required for the hashicorp/* namespace as a measure of
      # backward compatibility for commonly-used providers, but recommended for
      # explicitness.
      source  = "launchdarkly/launchdarkly"
      version = "~> 1.0"
    }
}
}

resource "launchdarkly_project" "demo" {
  key  = "tarq-terraform"
  name = "Tarq Terraform"
  tags = [
    "terraform",
  ]
}

resource "launchdarkly_environment" "base" {
  name  = "Base"
  key   = "base"
  color = "23abf5"
  tags  = ["terraform"]

  project_key = launchdarkly_project.demo.key
}

resource "launchdarkly_feature_flag" "enable_new_feature" {
  project_key = launchdarkly_project.demo.key
  key         = "enable-new-feature"
  name        = "Enable: New Feature"
  description = "This is a feature"
  variation_type = "boolean"
  default_off_variation = false
  default_on_variation = false
}


output "project" {
  value = launchdarkly_project.demo
}

output "environment" {
  value = launchdarkly_environment.base
}



/*
resource "launchdarkly_custom_role" "allow_access_to_staging" {
  count = 0
  key         = "staging-access"
  name        = "${launchdarkly_project.demo.name} ${launchdarkly_environment.staging.name}"
  description = "Allow all Actions ${launchdarkly_project.demo.name} ${launchdarkly_environment.staging.name}"

  policy {
    effect    = "allow"
    resources = ["proj/${launchdarkly_project.demo.key}:env/${launchdarkly_environment.staging.key}"]
    actions   = ["*"]
  }
}
*/
