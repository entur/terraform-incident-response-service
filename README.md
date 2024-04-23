# Terraform module for setting up services for incident response

This module is used for creating and updating services in the current incident response solution
PagerDuty. Services set up through this solution will have dependencies and incident response team
attached so that notifications get routed correctly and that the consequences of errors in dependencies
are visible.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.1.7 |
| <a name="requirement_pagerduty"></a> [pagerduty](#requirement\_pagerduty) | 3.6.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_pagerduty"></a> [pagerduty](#provider\_pagerduty) | 3.6.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [pagerduty_service.service](https://registry.terraform.io/providers/pagerduty/pagerduty/3.6.0/docs/resources/service) | resource |
| [pagerduty_service_dependency.parent](https://registry.terraform.io/providers/pagerduty/pagerduty/3.6.0/docs/resources/service_dependency) | resource |
| [pagerduty_service_dependency.supporting_business_services](https://registry.terraform.io/providers/pagerduty/pagerduty/3.6.0/docs/resources/service_dependency) | resource |
| [pagerduty_service_dependency.supporting_services](https://registry.terraform.io/providers/pagerduty/pagerduty/3.6.0/docs/resources/service_dependency) | resource |
| [pagerduty_business_service.business-services](https://registry.terraform.io/providers/pagerduty/pagerduty/3.6.0/docs/data-sources/business_service) | data source |
| [pagerduty_business_service.parent-business-service](https://registry.terraform.io/providers/pagerduty/pagerduty/3.6.0/docs/data-sources/business_service) | data source |
| [pagerduty_escalation_policy.ep](https://registry.terraform.io/providers/pagerduty/pagerduty/3.6.0/docs/data-sources/escalation_policy) | data source |
| [pagerduty_service.micro-services](https://registry.terraform.io/providers/pagerduty/pagerduty/3.6.0/docs/data-sources/service) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_pagerduty_token"></a> [pagerduty\_token](#input\_pagerduty\_token) | Pagerduty API token | `string` | n/a | yes |
| <a name="input_service_manifest"></a> [service\_manifest](#input\_service\_manifest) | The specification yaml of the service | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | n/a |
| <a name="output_name"></a> [name](#output\_name) | n/a |
<!-- END_TF_DOCS -->