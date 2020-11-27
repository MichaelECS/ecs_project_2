resource "aws_ecs_cluster" "mike_al_cluster_dev" {
  name = "mike-al-cluster-dev"
}

data "template_file" "task_template" {
  template = file("${path.module}/task-definition.json")

  vars = {
    cw_group = aws_cloudwatch_log_group.mike_al_cw.name
    aws_region = var.region
  }
}

resource "aws_ecs_task_definition" "mike_al_task_dev" {
  family                = "worker_dev"
  container_definitions = data.template_file.task_template.rendered
  
  requires_compatibilities = [
    "FARGATE"
  ]
  cpu = var.container_cpu
  memory = var.container_memory
  network_mode = "awsvpc"
  execution_role_arn = aws_iam_role.mikeAlEcsTaskExecutionRole.arn
}

resource "aws_ecs_service" "mike_al_service_dev" {
  name            = "mike_al_service_dev"
  cluster         = aws_ecs_cluster.mike_al_cluster_dev.id
  task_definition = aws_ecs_task_definition.mike_al_task_dev.arn
  launch_type     = "FARGATE"
  desired_count   = 1

  load_balancer {
    target_group_arn = aws_lb_target_group.mike_al_alb_tg_dev.arn # Referencing our target group
    container_name   = aws_ecs_task_definition.mike_al_task_dev.family
    container_port   = var.http_port
  }

  network_configuration {
    subnets = [
      aws_subnet.mike_al_VPC_SubnetOne_dev.id,
      aws_subnet.mike_al_VPC_SubnetTwo_dev.id
    ]
    assign_public_ip = true # Providing our containers with public IPs
    security_groups = [aws_security_group.mike_al_service_sg_dev.id]
  }
}

resource "aws_security_group" "mike_al_service_sg_dev" {
  vpc_id = aws_vpc.mike_al_VPC_dev.id
  name   = "mike-al-service-sg-dev"

  ingress {
    from_port       = 0
    to_port         = 0
    protocol        = -1
    security_groups = [aws_security_group.mike_al_alb_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_iam_role" "mikeAlEcsTaskExecutionRole_dev" {
  name               = "mikeAlEcsTaskExecutionRole-dev"
  assume_role_policy = data.aws_iam_policy_document.mike_al_assume_role_policy.json
}

data "aws_iam_policy_document" "mike_al_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "mikeAlEcsTaskExecutionRole_policy_dev" {
  role       = aws_iam_role.mikeAlEcsTaskExecutionRole_dev.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_cloudwatch_log_group" "mike_al_cw_dev" {
  name = "mike-al-cw-dev"
}