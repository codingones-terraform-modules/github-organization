variable "terraform_organization" {
  description = "The organization name on terraform cloud"
  nullable    = false
  default     = false
}

variable "github_organization_secrets" {
  description = "A map of secrets to define at the organization level from terraform organization variables"
  type = map(object({
    github_key    = string
    terraform_key = string
  }))
  nullable = true
  default = {
    tfe_team_token = {
      github_key    = "TF_API_TOKEN"
      terraform_key = "tfe_team_token"
    }
    notify_hook_url = {
      github_key    = "NOTIFICATION_WEBHOOK"
      terraform_key = "notification_webhook"
    }
  }
}

variable "github_organization_variables" {
  description = "A map of variables to define at the organization level from terraform organization variables"
  type = map(object({
    github_key    = string
    terraform_key = string
  }))
  nullable  = true
  default   = {}
}