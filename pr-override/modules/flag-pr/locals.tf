locals {
  pr_attribute = "Pull Request (TERRAFORM ONLY)"
  rules = data.launchdarkly_feature_flag_environment.base.rules
  uniq_variations = distinct(values(var.prs))

  prs_by_variation = {
    for variation in local.uniq_variations: 
      variation => matchkeys(keys(var.prs), values(var.prs), [variation])
  }

  matched_rules = [
    for rule in local.rules:
    merge({ is_pr_rule = (
      (length(rule.clauses) == 1 &&
      try(index(local.uniq_variations, rule.variation) != null, false) &&
      rule.clauses[0].attribute == local.pr_attribute &&
      rule.clauses[0].op == "in" &&
      rule.clauses[0].negate == false))
    }, rule)
    
  ]

  modified_rules = flatten([
    for rule in local.matched_rules:
      rule.is_pr_rule == true ? try(
        [merge(rule, { 
          clauses = [
          merge( rule.clauses[0], 
            { values = distinct(concat(
                                        local.prs_by_variation[index(local.uniq_variations, rule.clause[0].values)]))
            })
          ]
        })]
        , []) : [rule]
      ])
  // variations we need new rules for 
  new_rule_variations = setsubtract(toset(local.uniq_variations), toset((flatten([ for rule in local.modified_rules: rule.is_pr_rule ? [rule.variation] : [] ]))))
  // combine new rules and modified/existing rules
  pr_rules = concat([ for v in local.new_rule_variations: {
      is_pr_rule = true
      clauses =  [{
      attribute = local.pr_attribute
      op        = "in"
      values    = local.prs_by_variation[v]
      negate    = false
    }]
    variation = v
  }], local.modified_rules)

  flag_id = "${var.project_key}/${var.flag_key}"
}

output "found_rules" {
  value = [ for rule in local.modified_rules: rule  ]
}

output "new_rule_variations" {
  value = local.new_rule_variations
}

output "uniq_variations" {
  value = toset(local.uniq_variations)
}