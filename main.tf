
# Define local values for cluster domain, service URL, and Consul enablement
locals {
  cluster_domain = "${var.ecs_cluster}.${var.platform_config["dns_domain"]}"
  service_url    = "${var.service_name}.${local.cluster_domain}"
  enable_consul = var.external_url == "" ? 0 : 1
}


# Creates a CNAME DNS record in Route 53 for the specified service.
# The record is created in the DNS zone defined by 'dns_zone_id' from the 
# platform configuration module. The record name is set dynamically based 
# on the local service URL, and the value points to an internal subdomain 
# (e.g., internal.<cluster_domain>). TTL is set to 60 seconds for frequent updates.

resource "aws_route53_record" "dns_record" {
  provider = aws.dns
  zone_id  = var.platform_config["dns_zone_id"]
  name     = "${var.service_name}.${local.cluster_domain}"
  type     = "CNAME"
  records  = ["internal.${local.cluster_domain}"]
  ttl      = 60
}


# Creates an ALB listener rule to forward traffic based on specific conditions.
# The rule is applied to the listener defined by 'alb_listener_arn' from the 
# platform configuration module. The action forwards traffic to the specified 
# target group, 'service_target_group'. The rule applies to requests with 
# matching host headers (e.g., service URL and service name). Additionally, 
# it matches all paths ("*") for the given service.

resource "aws_alb_listener_rule" "rule" {
  provider     = aws.cluster_provider
  listener_arn = var.platform_config["alb_listener_arn"]

  action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.service_target_group.arn
  }

  condition {
    host_header {
      values = compact([
        "${local.service_url}",
        "${var.external_url}"
      ])
    }
  }

  condition {
    path_pattern {
      values = ["*"]
    }
  }
}


# Creates an ALB target group for the service, with a dynamic name based on 
# the service name and ECS cluster. The group listens on port 31337 (which 
# will be set dynamically, but AWS requires a placeholder value) using the 
# HTTP protocol. The target group is associated with the VPC specified in 
# the platform configuration module.

# AWS limits Target Group names to 32 characters. To ensure uniqueness and
# readability, we combine shortened versions of the service name and ECS
# cluster name with a hash suffix.

resource "aws_alb_target_group" "service_target_group" {

  provider = aws.cluster_provider

  name                 = md5("${var.service_name}-${var.ecs_cluster}")
  port                 = "31337"
  protocol             = "HTTP"
  vpc_id               = var.platform_config["vpc"]
  deregistration_delay = var.deregistration_delay

  health_check {
    path                = var.health_check_path
    interval            = var.health_check_interval
    timeout             = var.health_check_timeout
    healthy_threshold   = var.health_check_healthy_threshold
    unhealthy_threshold = var.health_check_unhealthy_threshold
    matcher             = var.health_check_matcher
  }

  tags = {
    FullName = "${var.service_name}-${var.ecs_cluster}-tg"
  }

}


# Registers a Consul service for the ecs service. The service listens on port 443
# and is tagged with details such as the service name, address, ACL tags, SSL configuration, 
# and protocol (HTTPS). The tags are used by nginx to setup the need config and rule the same
# why that is currently done in BSG-Release-Version. Migration to Ion's networking/routing
# patterns may be needed later, but is out of scope for cdflow adoption project.

resource "consul_node" "service_node" {
  provider = consul.bsg_consul
  count    = local.enable_consul
  name     = local.service_url
  address  = local.service_url
}

resource "consul_service" "service_node" {
  provider = consul.bsg_consul
  count    = local.enable_consul

  name = local.service_url
  node = consul_node.service_node[count.index].name
  port = 443

  tags = [
    "urlprefix-${var.external_url}",
    "acl-${var.bsg_consul_acl}",
    "service-${consul_node.service_node[count.index].address}:443",
    "ports-443 ssl",
    "proto-https",
    "cert-backstop.solutions"
  ]

}


