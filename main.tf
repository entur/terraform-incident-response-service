locals {
  service_spec          = yamldecode(var.service_manifest)
  dependencies          = { for service in local.service_spec.service-dependencies : try(service.name, service) => try(service.type, "service") }
  business-dependencies = toset([for name, type in local.dependencies : name if type == "business-service"])
  micro-services        = toset([for name, type in local.dependencies : name if type == "service"])
}

data "pagerduty_escalation_policy" "ep" {
  name = title(local.service_spec.team)
}

data "pagerduty_service" "micro-services" {
  for_each = local.micro-services
  name     = each.value
}

data "pagerduty_business_service" "business-services" {
  for_each = local.business-dependencies
  name     = each.value
}

data "pagerduty_business_service" "parent-business-service" {
  name = local.service_spec.business-service
}

resource "pagerduty_service" "service" {
  name                    = title(local.service_spec.name)
  description             = local.service_spec.description
  auto_resolve_timeout    = "86400"
  acknowledgement_timeout = "3600"
  escalation_policy       = data.pagerduty_escalation_policy.ep.id
  alert_creation          = "create_alerts_and_incidents"
  alert_grouping_parameters {
    type = "intelligent"
  }
  auto_pause_notifications_parameters {
    enabled = true
    timeout = 300
  }
}

resource "pagerduty_service_dependency" "parent" {
  count = try(local.service_spec.business-service, "") == "" ? 0 : 1
  dependency {
    dependent_service {
      id   = data.pagerduty_business_service.parent-business-service.id
      type = "business_service"
    }
    supporting_service {
      id   = pagerduty_service.service.id
      type = pagerduty_service.service.type
    }
  }
}

resource "pagerduty_service_dependency" "supporting_services" {
  for_each = data.pagerduty_service.micro-services
  dependency {
    dependent_service {
      id   = pagerduty_service.service.id
      type = pagerduty_service.service.type
    }
    supporting_service {
      id   = each.value.id
      type = each.value.type
    }
  }
}

resource "pagerduty_service_dependency" "supporting_business_services" {
  for_each = data.pagerduty_business_service.business-services
  dependency {
    dependent_service {
      id   = pagerduty_service.service.id
      type = pagerduty_service.service.type
    }
    supporting_service {
      id   = each.value.id
      type = each.value.type
    }
  }
}
