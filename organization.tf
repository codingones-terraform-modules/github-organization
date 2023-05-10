resource "github_actions_organization_secret" "tfe_team_token" {
  secret_name     = "TF_API_TOKEN"
  visibility      = "all"
  plaintext_value = var.tfe_team_token
}

# TODO Ajouter des PATs ici ?