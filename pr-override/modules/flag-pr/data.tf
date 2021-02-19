

data "launchdarkly_feature_flag_environment" "base" {
  flag_id = local.flag_id
  env_key = var.env_key
}
