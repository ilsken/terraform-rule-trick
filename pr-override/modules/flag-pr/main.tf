
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
data "launchdarkly_feature_flag_environment" "target_feature" {
  flag_id = local.flag_id
  env_key = var.env_key
}


resource "launchdarkly_feature_flag_environment" "target_feature" {
  flag_id = local.flag_id
  env_key = var.env_key
  
  dynamic "rules" {
    for_each = local.pr_rules
    content  {
      dynamic "clauses" {
        for_each = rules.value.clauses
        content {
         attribute = clauses.value.attribute
         op = clauses.value.op
         values = clauses.value.values
         negate = clauses.value.negate
       } 
       }
       variation = try(rules.value.variation,null)
       rollout_weights = try(rules.value.rollout_weights, [])
       bucket_by = try(rules.value.bucket_by, null)
    }
  }
}