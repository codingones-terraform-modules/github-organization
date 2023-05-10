variable "tfe_team_token" {
  description = "A GitHub Personal Access Token with the admin:org, repo, workflow, user scopes"
  nullable    = false
  default     = false
  sensitive   = true
}
