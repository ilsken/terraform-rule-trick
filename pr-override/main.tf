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

# Optional: Use long-term remote state as a data source to get the flag keys etc
data "terraform_remote_state" "base" {
  
  backend = "local"

  config = {
    path = "../base/terraform.tfstate"
  }
}



module "feature-flag-pr-rules" {
  for_each = var.prs
  source = "./modules/add-pr"
  project_key = data.terraform_remote_state.base.outputs.project.key
  env_key = data.terraform_remote_state.base.outputs.environment.key
  flag_variations = each.value
  add_pr = each.key
}

