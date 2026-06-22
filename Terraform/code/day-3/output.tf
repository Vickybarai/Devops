output "lb_endpoint" {
    value = aws_lb.application_load_balancer.dns_name
}