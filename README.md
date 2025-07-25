# terraform-bsg-ecs-service-registration

This module provisions infrastructure resources connecting a ECS service created by the [terraform-iona-ecs-service](https://github.com/ION-Analytics/terraform-iona-ecs-service) TF module to an AWS Application Load Balancer (ALB) managed by the [BSG-Terraform-Internal-ECS-Routers](https://github.com/ION-Analytics/BSG-Terraform-Internal-ECS-Routers), with optional Consul service registration. The Consul configuration is used for routing 

**Key Components**

* Route 53 DNS Record
* ALB Listener Rule
* ALB Target Group with Health Check
* Consul Service Registration for BSG internal or external address routing(Optional) 

*NOTE: The Consul registration and configs are used by BSG NGINX to set up the necessary ACL and LB configuration for internal and external networking. Migration to Ion's networking and routing patterns may be required in the future, but this is out of scope for the cdflow adoption initiative.*