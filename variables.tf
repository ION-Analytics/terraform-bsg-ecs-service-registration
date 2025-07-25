########################
# Custer Configuration #
########################

variable "platform_config" {
  description = "Platform configuration"
  type        = map(string)
  default     = {}
}

variable "service_name" {
  type        = string
  description = "The name of the service."
}

variable "ecs_cluster" {
  type        = string
  description = "The name of the ecs_cluster."
}

####################
# External Routing #
####################            

variable "bsg_consul_acl" {
  type        = string
  description = "Which BSG consul acl to use (internal, external or officeaccess)"
  default     = "internal"

}

variable "external_url" {
  type        = string
  description = <<-EOT
    The external URL that should be routable to this service.

    Ensure that this DNS entry is defined in the external DNS repository.

    Note: Setting this value enables all related configurations,
    but it does *NOT* allow external access to the services by itself.
    To allow external access, you must also set the `bsg_consul_acl` variable.
  EOT
  default     = ""
}


################
# Health Check #
################                

variable "health_check_path" {
  description = "The path to use for health checks"
  type        = string
  default     = "/"
}

variable "health_check_interval" {
  description = "The interval between health checks"
  type        = string
  default     = "10"
}

variable "health_check_timeout" {
  description = "The time to wait before marking a health check as failed"
  type        = string
  default     = "5"
}

variable "health_check_healthy_threshold" {
  description = "The number of consecutive successful checks before considering the target healthy"
  type        = string
  default     = "4"
}

variable "health_check_unhealthy_threshold" {
  description = "The number of consecutive failed checks before considering the target unhealthy"
  type        = string
  default     = "4"
}

variable "health_check_matcher" {
  description = "The HTTP status codes to consider a successful response"
  type        = string
  default     = "200-299"
}

variable "deregistration_delay" {
  description = "Delay before deregistration"
  type        = string
  default     = "30"
}
