variable "launchdarkly_access_token" {
	type=string
}

variable "prs" {
	type=map(map(number))
	description = "Defines mapping of PR -> Feature -> Variation"
}
