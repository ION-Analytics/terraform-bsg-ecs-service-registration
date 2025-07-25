# terraform-bsg-ecs-service-registration

This module provisions infrastructure resources connecting a ECS service created by the [terraform-iona-ecs-service](https://github.com/ION-Analytics/terraform-iona-ecs-service) TF module to an AWS Application Load Balancer (ALB) managed by the [BSG-Terraform-Internal-ECS-Routers](https://github.com/ION-Analytics/BSG-Terraform-Internal-ECS-Routers), with optional Consul service registration. The Consul configuration is used for routing 

**Key Components**

* Route 53 DNS Record
* ALB Listener Rule
* ALB Target Group with Health Check
* Consul Service Registration for BSG internal or external address routing(Optional) 

*NOTE: The Consul registration and configs are used by BSG NGINX to set up the necessary ACL and LB configuration for internal and external networking. Migration to Ion's networking and routing patterns may be required in the future, but this is out of scope for the cdflow adoption initiative.*

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws.cluster_provider"></a> [aws.cluster\_provider](#provider\_aws.cluster\_provider) | n/a |
| <a name="provider_aws.dns"></a> [aws.dns](#provider\_aws.dns) | n/a |
| <a name="provider_consul.bsg_consul"></a> [consul.bsg\_consul](#provider\_consul.bsg\_consul) | 2.15.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_alb_listener_rule.rule](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/alb_listener_rule) | resource |
| [aws_alb_target_group.service_target_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/alb_target_group) | resource |
| [aws_route53_record.dns_record](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [consul_node.service_node](https://registry.terraform.io/providers/hashicorp/consul/2.15.0/docs/resources/node) | resource |
| [consul_service.service_node](https://registry.terraform.io/providers/hashicorp/consul/2.15.0/docs/resources/service) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_bsg_consul_acl"></a> [bsg\_consul\_acl](#input\_bsg\_consul\_acl) | Which BSG consul acl to use (internal, external or officeaccess) | `string` | `"internal"` | no |
| <a name="input_deregistration_delay"></a> [deregistration\_delay](#input\_deregistration\_delay) | Delay before deregistration | `string` | `"30"` | no |
| <a name="input_ecs_cluster"></a> [ecs\_cluster](#input\_ecs\_cluster) | The name of the ecs\_cluster. | `string` | n/a | yes |
| <a name="input_external_url"></a> [external\_url](#input\_external\_url) | The external URL that should be routable to this service.<br/><br/>Ensure that this DNS entry is defined in the external DNS repository.<br/><br/>Note: Setting this value enables all related configurations,<br/>but it does *NOT* allow external access to the services by itself.<br/>To allow external access, you must also set the `bsg_consul_acl` variable. | `string` | `""` | no |
| <a name="input_health_check_healthy_threshold"></a> [health\_check\_healthy\_threshold](#input\_health\_check\_healthy\_threshold) | The number of consecutive successful checks before considering the target healthy | `string` | `"4"` | no |
| <a name="input_health_check_interval"></a> [health\_check\_interval](#input\_health\_check\_interval) | The interval between health checks | `string` | `"10"` | no |
| <a name="input_health_check_matcher"></a> [health\_check\_matcher](#input\_health\_check\_matcher) | The HTTP status codes to consider a successful response | `string` | `"200-299"` | no |
| <a name="input_health_check_path"></a> [health\_check\_path](#input\_health\_check\_path) | The path to use for health checks | `string` | `"/"` | no |
| <a name="input_health_check_timeout"></a> [health\_check\_timeout](#input\_health\_check\_timeout) | The time to wait before marking a health check as failed | `string` | `"5"` | no |
| <a name="input_health_check_unhealthy_threshold"></a> [health\_check\_unhealthy\_threshold](#input\_health\_check\_unhealthy\_threshold) | The number of consecutive failed checks before considering the target unhealthy | `string` | `"4"` | no |
| <a name="input_platform_config"></a> [platform\_config](#input\_platform\_config) | Platform configuration | `map(string)` | `{}` | no |
| <a name="input_service_name"></a> [service\_name](#input\_service\_name) | The name of the service. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_service_target_group"></a> [service\_target\_group](#output\_service\_target\_group) | The ALB target group for the service |