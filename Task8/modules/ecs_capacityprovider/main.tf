# Capacity Provider
resource "aws_ecs_capacity_provider" "main" {
  name = "${var.name_prefix}-ecs-ec2"

  auto_scaling_group_provider {

    auto_scaling_group_arn         = var.auto_scaling_group_arn 
    managed_termination_protection = "DISABLED"

    managed_scaling {
      maximum_scaling_step_size = 2
      minimum_scaling_step_size = 1
      status                    = "ENABLED"
      target_capacity           = 100
    }
  }
}

resource "aws_ecs_cluster_capacity_providers" "main" {
  cluster_name       = var.ecs_cluster_name
  capacity_providers = [aws_ecs_capacity_provider.main.name]

  default_capacity_provider_strategy {
    capacity_provider = aws_ecs_capacity_provider.main.name
    base              = 1
    weight            = 100
  }
}