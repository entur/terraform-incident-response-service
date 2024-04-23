variables {
  pagerduty_token = "test_dummy"
  service_manifest   = file("./tests/service.yaml")
}

mock_provider "pagerduty" {

  override_data {
    target = data.pagerduty_business_service.parent-business-service
    values = {
      id   = "PARENT_ID"
      name = "core"
    }
  }

  override_data {
    target = data.pagerduty_escalation_policy.ep
    values = {
      id   = "EP_ID"
      name = "test-ep"
    }
  }

  override_data {
    target = data.pagerduty_service.micro-services
    values = {
        id   = "TECHNICAL_SERVICE_ID"
        val = "test-technical-service"
    }
  }

  override_data {
    target = data.pagerduty_business_service.business-services
    values = {
        id   = "BUSINESS_SERVICE_ID"
        val = "test-business-service"
    }
  }
}

run "service_is_created_with_default_settings" {
  command = plan

  assert {
    condition     = pagerduty_service.service.name == "Test-Service"
    error_message = format("Service name is incorrect. Expected %s but was %s", "Test-Service", pagerduty_service.service.name)
  }

  assert {
    condition     = pagerduty_service.service.auto_resolve_timeout == "86400"
    error_message = format("Auto resolve timeout is incorrect. Expected %s but was %s", "86400", pagerduty_service.service.auto_resolve_timeout)
  }

  assert {
    condition     = pagerduty_service.service.acknowledgement_timeout == "3600"
    error_message = format("Acknowledgement timeout is incorrect. Expected %s but was %s", "3600", pagerduty_service.service.acknowledgement_timeout)
  }

  assert {
    condition     = pagerduty_service.service.alert_grouping_parameters[0].type == "intelligent"
    error_message = format("Alert grouping parameters is incorrect. Expected %s but was %s", "intelligent", pagerduty_service.service.alert_grouping_parameters[0].type)
  }
}

run "service_escalates_to_team_policy" {
  command = plan

  assert {
    condition     = pagerduty_service.service.escalation_policy == "EP_ID"
    error_message = format("Escalation policy is incorrect. Expected %s but was %s", "EP_ID", pagerduty_service.service.escalation_policy)
  }
}

run "parent_business_service_is_bound" {
  command = plan

  assert {
    condition     = pagerduty_service_dependency.parent[0].dependency[0].dependent_service[0].id == "PARENT_ID"
    error_message = "Parent service is incorrect."
  }
}

run "business_dependencies_are_bound" {
  command = plan

  assert {
    condition     = pagerduty_service_dependency.supporting_business_services["test-business-service"].dependency[0].supporting_service[0].id == "BUSINESS_SERVICE_ID"
    error_message = "Business service is incorrect."
  }
}

run "technical_dependencies_are_bound" {
  command = plan

  assert {
    condition     = pagerduty_service_dependency.supporting_services["test-technical-service"].dependency[0].supporting_service[0].id == "TECHNICAL_SERVICE_ID"
    error_message = "Technical service is incorrect."
  }
}
