data "tfe_variable_set" "public" {
  name         = "variables"
  organization = var.terraform_organization
}

data "tfe_variables" "variables" {
  variable_set_id = data.tfe_variable_set.public.id
}

locals {
  secrets_indexes = {
    for entry in var.github_organization_secrets : entry.terraform_key => try((index(data.tfe_variables.variables.terraform.*.name, entry.terraform_key) >= 0 ? index(data.tfe_variables.variables.terraform.*.name, entry.terraform_key) : -1), -1)
  }
}

locals {
  secrets_associative_map = {
    for entry in var.github_organization_secrets : entry.github_key => local.secrets_indexes[entry.terraform_key] != -1 ? element(data.tfe_variables.variables.terraform, local.secrets_indexes[entry.terraform_key]).value : "SECRET_NOT_FOUND_IN_TERRAFORM_ORGANIZATION_VARIABLES"
  }
}

locals {
  variables_indexes = {
    for entry in var.github_organization_variables : entry.terraform_key => try((index(data.tfe_variables.variables.terraform.*.name, entry.terraform_key) >= 0 ? index(data.tfe_variables.variables.terraform.*.name, entry.terraform_key) : -1), -1)
  }
}

locals {
  variables_associative_map = {
    for entry in var.github_organization_variables : entry.github_key => local.variables_indexes[entry.terraform_key] != -1 ? element(data.tfe_variables.variables.terraform, local.variables_indexes[entry.terraform_key]).value : "VARIABLE_NOT_FOUND_IN_TERRAFORM_ORGANIZATION_VARIABLES"
  }
}

resource "github_actions_organization_secret" "secrets" {
  for_each = local.secrets_associative_map

  secret_name     = each.key
  visibility      = "all"
  plaintext_value = each.value
}

resource "github_actions_organization_variable" "variables" {
  for_each = local.variables_associative_map

  variable_name = each.key
  visibility    = "all"
  value         = each.value
}