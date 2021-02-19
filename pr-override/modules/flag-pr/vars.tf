variable "prs" {
  type = map(number)
  description = "map of PR -> variation"
}



variable "project_key" {
  type = string
  description = "LaunchDarkly Project Key"
}

variable "env_key" {
  type = string
  description = "LaunchDarkly Project Key"
}


variable "flag_key" {
  type = string
  description = "LaunchDarkly Flag Key"
}

