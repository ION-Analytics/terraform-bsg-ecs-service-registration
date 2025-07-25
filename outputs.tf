output "service_target_group" {
  value       = aws_alb_target_group.service_target_group
  description = "The ALB target group for the service"
}