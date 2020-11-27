resource "aws_alb" "mike_al_alb" {
  name               = "mike-al-alb"
  load_balancer_type = "application"
  subnets = [
    aws_subnet.mike_al_VPC_SubnetOne.id,
    aws_subnet.mike_al_VPC_SubnetTwo.id,
  ]
  security_groups = [aws_security_group.mike_al_alb_sg.id]
}

# Creating a security group for the load balancer
resource "aws_security_group" "mike_al_alb_sg" {
  vpc_id = aws_vpc.mike_al_VPC.id
  name   = "mike-al-alb-sg"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_lb_target_group" "mike_al_alb_tg" {
  name        = "mike-al-alb-tg"
  port        = var.http_port
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = aws_vpc.mike_al_VPC.id

  depends_on = [
    aws_alb.mike_al_alb
  ]

  health_check {
    matcher = "200,301,302"
    path = "/"
    unhealthy_threshold = 2
    interval = 10
  }
}

resource "aws_lb_listener" "mike_al_alb_listener" {
  load_balancer_arn = aws_alb.mike_al_alb.arn
  port              = var.http_port
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.mike_al_alb_tg.arn
  }
}