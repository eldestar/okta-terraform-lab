terraform {
  required_version = ">= 1.7.0"

  required_providers {
    okta = {
      source  = "okta/okta"
      version = "~> 4.0"
    }
  }
}

provider "okta" {
  # Reads OKTA_ORG_NAME, OKTA_BASE_URL and OKTA_API_TOKEN from the environment.
  # Never put these in a file.
}
