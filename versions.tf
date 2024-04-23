terraform {
  required_version = ">= 1.1.7"
  required_providers {
    pagerduty = {
      source  = "pagerduty/pagerduty"
      version = "3.6.0"
    }
  }
}

provider "pagerduty" {
  token      = var.pagerduty_token
  user_token = var.pagerduty_token
}
