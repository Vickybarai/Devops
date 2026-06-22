resource "aws_lb_target_group" "home_target_group" {
    name = "${var.project}-${var.env}-home-tg"
    port = 80
    protocol = "HTTP"
    vpc_id = data.aws_vpc.default.id
    health_check {
        enabled = true
        path = "/"
        port = "traffic-port"
        protocol = "HTTP"       
    }
}

resource "aws_lb_target_group" "mobile_target_group" {
    name = "${var.project}-${var.env}-mobile-tg"
    port = 80
    protocol = "HTTP"
    health_check {
        enabled = true
        path = "/mobile/"
        port = "traffic-port"
        protocol = "HTTP"       
    }
    vpc_id = data.aws_vpc.default.id
}

resource "aws_lb_target_group" "laptop_target_group" {
    name = "${var.project}-${var.env}-laptop-tg"
    port = 80
    protocol = "HTTP"
    health_check {
        enabled = true
        path = "/laptop/"
        port = "traffic-port"
        protocol = "HTTP"       
    }
    vpc_id = data.aws_vpc.default.id
}

data "aws_subnets" "my_subnets" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}
resource "aws_lb" "application_load_balancer" {
    name = "${var.project}-${var.env}-alb"
    internal = false
    load_balancer_type = "application"
    security_groups = [aws_security_group.security_group.id]
    subnets = data.aws_subnets.my_subnets.ids
}

resource "aws_lb_listener" "application_load_balancer_listener" {
    load_balancer_arn = aws_lb.application_load_balancer.arn
    port = 80
    protocol = "HTTP"
    default_action {
        type = "forward"
        target_group_arn = aws_lb_target_group.home_target_group.arn
    }
}

resource "aws_lb_listener_rule" "laptop_listener_rule" {
    listener_arn = aws_lb_listener.application_load_balancer_listener.arn
    priority = 101  
    action {
        type             = "forward"
        target_group_arn = aws_lb_target_group.laptop_target_group.arn
    }

  condition {
    path_pattern {
      values = ["/laptop/*"]
    }
  }
}

resource "aws_lb_listener_rule" "mobile_listener_rule" {
    listener_arn = aws_lb_listener.application_load_balancer_listener.arn
    priority = 100  
    action {
        type             = "forward"
        target_group_arn = aws_lb_target_group.mobile_target_group.arn
    }

  condition {
    path_pattern {
      values = ["/mobile/*"]
    }
  }
}



    