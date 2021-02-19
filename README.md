# guide


## ./base

TF project that uses persistent state, configures the long lived resources such as:

- Projects
- Environments
- Flags

Should use persisted state/remote state.


## pr-override

TF project that should be run on each PR. Persisted state is helpful but not required.

### How it works

- Acts as an "Append a value to a rule" module 
- Grabs the current ruleset using the feature flag environment data source
- Modifies existing "Pull Request (TERRAFORM)" rules and modifies them
- Adds pull request rules if they do not exist
- Returns the modified set of rules 

In affect, changes to the rules will not be clobbered by terraform. 

### usage

On each PR, run:

```
cd pr-override
terraform apply -var-file=../prs.tfvars -var lanchdarkly_api_token="$API_TOKEN" -target "module.feature-flag-pr-rules[\"$CURRENT_PR\"]"
```

### configuration

The variable `prs` should be a map of PR labels to a map of flag keys and variations (index, 0 = true, 1 = false by default)

```
prs = {
  "pr11" = {
    "enable-new-feature" = 0
  }
}
```
