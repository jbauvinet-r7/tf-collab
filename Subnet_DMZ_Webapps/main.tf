#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
#                                                                                                                                                                               #
#                                                                Welcome to the Rapid7 Global Lab Terraform                                                                     #
#                            Created by : Jean-Baptiste AUVINET                          Version : 1                          Date : 04/08/2024                                 #
#                                                                             DMZ Ext Collector Variables                                                                       #
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#

#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
#  AWS CloudWatch                                                                                                                                                                                                                                                   
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
resource "aws_cloudwatch_log_group" "webapps" {
  name = "${var.Tenant}-WebApps"

  tags = {
    "Name"        = "${var.Tenant}-CloudWatch-LG"
    "Tenant"      = "${var.Tenant}"
    "Owner_Email" = "${var.Owner_Email}"
    "JIRA_ID"     = "${var.JIRA_ID}"
  }
}

#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
#  IAM Role                                                                                                                                                                                                                                              
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
resource "aws_iam_role" "ecsTaskExecutionRole" {
  name               = "${var.Tenant}-webapps-app-ecsTaskExecutionRole"
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
  tags = {
    "Name"        = "${var.Tenant}-aws_iam_role-webapps"
    "Tenant"      = "${var.Tenant}"
    "Owner_Email" = "${var.Owner_Email}"
    "JIRA_ID"     = "${var.JIRA_ID}"
  }
}
resource "aws_iam_role" "ecsTaskRole" {
  name               = "${var.Tenant}-ecsTaskRole"
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
  tags = {
    "Name"        = "${var.Tenant}-ecsTaskRole"
    "Tenant"      = "${var.Tenant}"
    "Owner_Email" = "${var.Owner_Email}"
    "JIRA_ID"     = "${var.JIRA_ID}"
  }
}

#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
#  IAM Policy                                                                                                                                                                                                                                             
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
#  IAM Policy Attachment                                                                                                                                                                                                                                           
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
resource "aws_iam_role_policy_attachment" "ecsTaskExecutionRole_policy" {
  role       = aws_iam_role.ecsTaskExecutionRole.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
#  ECS Cluster                                                                                                                                                                                                                            
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
resource "aws_ecs_cluster" "webapps" {
  name = "${var.Tenant}-webapps-cluster"
}
resource "aws_ecs_cluster_capacity_providers" "cluster" {
  cluster_name       = aws_ecs_cluster.webapps.name
  capacity_providers = ["FARGATE"]

  default_capacity_provider_strategy {
    base              = 1
    weight            = 100
    capacity_provider = "FARGATE"
  }
}

#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
#  ALB Target Group                                                                                                                                                                                                               
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
############# Juice Shop #############
resource "aws_lb_target_group" "juiceshop" {
  count       = var.InsightAppSec_Module == true && var.use_route53_hz == true ? 1 : 0
  name        = "${var.Tenant}-WebApps-juiceshop-tg"
  port        = var.Juice_Shop_Port
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"
  health_check {
    healthy_threshold   = "3"
    interval            = "30"
    protocol            = "HTTP"
    matcher             = "200"
    timeout             = "3"
    path                = "/"
    unhealthy_threshold = "2"
  }
}

############# Log4j #############
resource "aws_lb_target_group" "log4j" {
  count       = var.InsightAppSec_Module == true && var.use_route53_hz == true ? 1 : 0
  name        = "${var.Tenant}-WebApps-log4j-tg"
  port        = var.Log4j_Port
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"
  health_check {
    healthy_threshold   = "3"
    interval            = "30"
    protocol            = "HTTP"
    matcher             = "200"
    timeout             = "3"
    path                = "/"
    unhealthy_threshold = "2"
  }
}

############# Hackazon #############
resource "aws_lb_target_group" "hackazon" {
  count       = var.InsightAppSec_Module == true && var.use_route53_hz == true ? 1 : 0
  name        = "${var.Tenant}-WebApps-hackazon-tg"
  port        = var.Hackazon_Port
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"
  health_check {
    healthy_threshold   = "3"
    interval            = "30"
    protocol            = "HTTP"
    matcher             = "200"
    timeout             = "3"
    path                = "/"
    unhealthy_threshold = "2"
  }
}

############# GraphQL #############
resource "aws_lb_target_group" "graphql" {
  count       = var.InsightAppSec_Module == true && var.use_route53_hz == true ? 1 : 0
  name        = "${var.Tenant}-WebApps-graphql-tg"
  port        = var.GraphQL_Port
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"
  health_check {
    healthy_threshold   = "3"
    interval            = "30"
    protocol            = "HTTP"
    matcher             = "200"
    timeout             = "3"
    path                = "/#!/welcome"
    unhealthy_threshold = "2"
    port                = "5013"
  }
}

############# crAPI #############
resource "aws_lb_target_group" "crapi443" {
  count       = var.InsightAppSec_Module == true && var.use_route53_hz == true ? 1 : 0
  name        = "${var.Tenant}-WebApps-crapi443-tg"
  port        = var.crAPI_Port_443
  protocol    = "HTTPS"
  vpc_id      = var.vpc_id
  target_type = "ip"
  health_check {
    healthy_threshold   = "3"
    interval            = "30"
    protocol            = "HTTPS"
    matcher             = "200"
    timeout             = "3"
    path                = "/"
    unhealthy_threshold = "2"
  }
}
resource "aws_lb_target_group" "crapi8025" {
  count       = var.InsightAppSec_Module == true && var.use_route53_hz == true ? 1 : 0
  name        = "${var.Tenant}-WebApps-crapi8025-tg"
  port        = var.crAPI_Port_8025
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"
  health_check {
    healthy_threshold   = "3"
    interval            = "30"
    protocol            = "HTTP"
    matcher             = "200"
    timeout             = "3"
    path                = "/"
    unhealthy_threshold = "2"
  }
}

############# Jenkins #############
resource "aws_lb_target_group" "jenkins" {
  count       = var.use_route53_hz == true && var.use_route53_hz == true ? 1 : 0
  name        = "${var.Tenant}-WebApps-jenkins-tg"
  port        = var.Jenkins_Port
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"
  health_check {
    healthy_threshold   = "3"
    interval            = "30"
    protocol            = "HTTP"
    matcher             = "200"
    timeout             = "3"
    path                = "/login"
    unhealthy_threshold = "2"
  }
}

############# PetClinic #############
resource "aws_lb_target_group" "petclinic" {
  count       = var.InsightAppSec_Module == true && var.use_route53_hz == true ? 1 : 0
  name        = "${var.Tenant}-WebApps-petclinic-tg"
  port        = var.PetClinic_Port
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"
  health_check {
    healthy_threshold   = "3"
    interval            = "30"
    protocol            = "HTTP"
    matcher             = "200"
    timeout             = "3"
    path                = "/#!/welcome"
    unhealthy_threshold = "2"
    port                = "3780"

  }
}
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
#  ALB Lister Rule                                                                                                                                                                                                       
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
############# Juice Shop #############
resource "aws_lb_listener_rule" "juiceshop" {
  count        = var.InsightAppSec_Module == true && var.use_route53_hz == true ? 1 : 0
  listener_arn = var.aws_lb_listener_webapps443_id
  priority     = var.Juice_Shop_Priority
  action {
    type             = "forward"
    target_group_arn = one(aws_lb_target_group.juiceshop[*].arn)
  }
  condition {
    host_header {
      values = ["juiceshop.${var.ZoneName}"]
    }
  }
}

############# Log4j #############
resource "aws_lb_listener_rule" "log4j" {
  count        = var.InsightAppSec_Module == true && var.use_route53_hz == true ? 1 : 0
  listener_arn = var.aws_lb_listener_webapps443_id
  priority     = var.Log4j_Priority

  action {
    type             = "forward"
    target_group_arn = one(aws_lb_target_group.log4j[*].arn)
  }

  condition {
    host_header {
      values = ["log4j.${var.ZoneName}"]
    }
  }
}

############# Hackazon #############
resource "aws_lb_listener_rule" "hackazon" {
  count        = var.InsightAppSec_Module == true && var.use_route53_hz == true ? 1 : 0
  listener_arn = var.aws_lb_listener_webapps443_id
  priority     = var.Hackazon_Priority

  action {
    type             = "forward"
    target_group_arn = one(aws_lb_target_group.hackazon[*].arn)
  }

  condition {
    host_header {
      values = ["hackazon.${var.ZoneName}"]
    }
  }
}

############# GraphQL #############
resource "aws_lb_listener_rule" "graphql" {
  count        = var.InsightAppSec_Module == true && var.use_route53_hz == true ? 1 : 0
  listener_arn = var.aws_lb_listener_webapps443_id
  priority     = var.GraphQL_Priority

  action {
    type             = "forward"
    target_group_arn = one(aws_lb_target_group.graphql[*].arn)
  }

  condition {
    host_header {
      values = ["graphql.${var.ZoneName}"]
    }
  }
}

############# crAPI #############
resource "aws_lb_listener_rule" "crapi443" {
  count        = var.InsightAppSec_Module == true && var.use_route53_hz == true ? 1 : 0
  listener_arn = var.aws_lb_listener_webapps443_id
  priority     = var.crAPI_Priority

  action {
    type             = "forward"
    target_group_arn = one(aws_lb_target_group.crapi443[*].arn)
  }

  condition {
    host_header {
      values = ["crapi.${var.ZoneName}"]
    }
  }
}
resource "aws_lb_listener_rule" "crapi8025" {
  count        = var.InsightAppSec_Module == true && var.use_route53_hz == true ? 1 : 0
  listener_arn = var.aws_lb_listener_webapps8025_id
  priority     = var.crAPI_Priority

  action {
    type             = "forward"
    target_group_arn = one(aws_lb_target_group.crapi8025[*].arn)
  }

  condition {
    host_header {
      values = ["crapi.${var.ZoneName}"]
    }
  }
}

############# Jenkins #############
resource "aws_lb_listener_rule" "jenkins" {
  count        = var.use_route53_hz == true ? 1 : 0
  listener_arn = var.aws_lb_listener_webapps443_id
  priority     = var.Jenkins_Priority

  action {
    type             = "forward"
    target_group_arn = one(aws_lb_target_group.jenkins[*].arn)
  }

  condition {
    host_header {
      values = ["jenkins.${var.ZoneName}"]
    }
  }
}

############# PetClinic #############
resource "aws_lb_listener_rule" "petclinic" {
  count        = var.InsightAppSec_Module == true && var.use_route53_hz == true ? 1 : 0
  listener_arn = var.aws_lb_listener_webapps443_id
  priority     = var.PetClinic_Priority

  action {
    type             = "forward"
    target_group_arn = one(aws_lb_target_group.petclinic[*].arn)
  }

  condition {
    host_header {
      values = ["petclinic.${var.ZoneName}"]
    }
  }
}

#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
#  ECS Service                                                                                                                                                                                                     
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
############# Juice Shop #############
resource "aws_ecs_service" "juiceshop_53" {
  count           = var.InsightAppSec_Module == true && var.use_route53_hz == true ? 1 : 0
  name            = "${var.Tenant}-juiceshop"
  cluster         = aws_ecs_cluster.webapps.id
  task_definition = one(aws_ecs_task_definition.juiceshop[*].arn)
  launch_type     = "FARGATE"
  desired_count   = 1
  network_configuration {
    security_groups  = [var.ecs_service_sg_id]
    subnets          = [var.subnet_dmzwebapp1_id, var.subnet_dmzwebapp2_id]
    assign_public_ip = true
  }
  load_balancer {
    target_group_arn = one(aws_lb_target_group.juiceshop[*].arn)
    container_name   = "${var.Tenant}-juiceshop-task"
    container_port   = var.Juice_Shop_Port
  }
  lifecycle {
    ignore_changes = [task_definition, desired_count]
  }
  depends_on = [var.aws_lb_listener_webapps443_id]
}

resource "aws_ecs_service" "juiceshop" {
  count           = var.InsightAppSec_Module == true && var.use_route53_hz != true ? 1 : 0
  name            = "${var.Tenant}-juiceshop"
  cluster         = aws_ecs_cluster.webapps.id
  task_definition = one(aws_ecs_task_definition.juiceshop[*].arn)
  launch_type     = "FARGATE"
  desired_count   = 1
  network_configuration {
    security_groups  = [var.ecs_service_sg_id]
    subnets          = [var.subnet_dmzwebapp1_id, var.subnet_dmzwebapp2_id]
    assign_public_ip = true
  }
  lifecycle {
    ignore_changes = [task_definition, desired_count]
  }
}


############# Log4j #############
resource "aws_ecs_service" "log4j_53" {
  count           = var.InsightAppSec_Module == true && var.use_route53_hz == true ? 1 : 0
  name            = "${var.Tenant}-log4j"
  cluster         = aws_ecs_cluster.webapps.id
  task_definition = one(aws_ecs_task_definition.log4j[*].arn)
  launch_type     = "FARGATE"
  desired_count   = 1
  network_configuration {
    security_groups  = [var.ecs_service_sg_id]
    subnets          = [var.subnet_dmzwebapp1_id, var.subnet_dmzwebapp2_id]
    assign_public_ip = true
  }
  load_balancer {
    target_group_arn = one(aws_lb_target_group.log4j[*].arn)
    container_name   = "${var.Tenant}-log4j-task"
    container_port   = var.Log4j_Port
  }
  lifecycle {
    ignore_changes = [task_definition, desired_count]
  }
  depends_on = [var.aws_lb_listener_webapps443_id]
}

resource "aws_ecs_service" "log4j" {
  count           = var.InsightAppSec_Module == true && var.use_route53_hz != true ? 1 : 0
  name            = "${var.Tenant}-log4j"
  cluster         = aws_ecs_cluster.webapps.id
  task_definition = one(aws_ecs_task_definition.log4j[*].arn)
  launch_type     = "FARGATE"
  desired_count   = 1
  network_configuration {
    security_groups  = [var.ecs_service_sg_id]
    subnets          = [var.subnet_dmzwebapp1_id, var.subnet_dmzwebapp2_id]
    assign_public_ip = true
  }
  lifecycle {
    ignore_changes = [task_definition, desired_count]
  }
}

############# Hackazon #############
resource "aws_ecs_service" "hackazon_53" {
  count           = var.InsightAppSec_Module == true && var.use_route53_hz == true ? 1 : 0
  name            = "${var.Tenant}-hackazon"
  cluster         = aws_ecs_cluster.webapps.id
  task_definition = one(aws_ecs_task_definition.hackazon[*].arn)
  launch_type     = "FARGATE"
  desired_count   = 1
  network_configuration {
    security_groups  = [var.ecs_service_sg_id]
    subnets          = [var.subnet_dmzwebapp1_id, var.subnet_dmzwebapp2_id]
    assign_public_ip = true
  }
  load_balancer {
    target_group_arn = one(aws_lb_target_group.hackazon[*].arn)
    container_name   = "${var.Tenant}-hackazon-task"
    container_port   = var.Hackazon_Port
  }
  lifecycle {
    ignore_changes = [task_definition, desired_count]
  }
  depends_on = [var.aws_lb_listener_webapps443_id]
}

resource "aws_ecs_service" "hackazon" {
  count           = var.InsightAppSec_Module == true && var.use_route53_hz != true ? 1 : 0
  name            = "${var.Tenant}-hackazon"
  cluster         = aws_ecs_cluster.webapps.id
  task_definition = one(aws_ecs_task_definition.hackazon[*].arn)
  launch_type     = "FARGATE"
  desired_count   = 1
  network_configuration {
    security_groups  = [var.ecs_service_sg_id]
    subnets          = [var.subnet_dmzwebapp1_id, var.subnet_dmzwebapp2_id]
    assign_public_ip = true
  }
  lifecycle {
    ignore_changes = [task_definition, desired_count]
  }
}

############# GraphQL #############
resource "aws_ecs_service" "graphql_53" {
  count           = var.InsightAppSec_Module == true && var.use_route53_hz == true ? 1 : 0
  name            = "${var.Tenant}-graphql"
  cluster         = aws_ecs_cluster.webapps.id
  task_definition = one(aws_ecs_task_definition.graphql[*].arn)
  launch_type     = "FARGATE"
  desired_count   = 1
  network_configuration {
    security_groups  = [var.ecs_service_sg_id]
    subnets          = [var.subnet_dmzwebapp1_id, var.subnet_dmzwebapp2_id]
    assign_public_ip = true
  }
  load_balancer {
    target_group_arn = one(aws_lb_target_group.graphql[*].arn)
    container_name   = "${var.Tenant}-graphql-task"
    container_port   = var.GraphQL_Port
  }
  lifecycle {
    ignore_changes = [task_definition, desired_count]
  }
  depends_on = [var.aws_lb_listener_webapps443_id]
}

resource "aws_ecs_service" "graphql" {
  count           = var.InsightAppSec_Module == true && var.use_route53_hz != true ? 1 : 0
  name            = "${var.Tenant}-graphql"
  cluster         = aws_ecs_cluster.webapps.id
  task_definition = one(aws_ecs_task_definition.graphql[*].arn)
  launch_type     = "FARGATE"
  desired_count   = 1
  network_configuration {
    security_groups  = [var.ecs_service_sg_id]
    subnets          = [var.subnet_dmzwebapp1_id, var.subnet_dmzwebapp2_id]
    assign_public_ip = true
  }
  lifecycle {
    ignore_changes = [task_definition, desired_count]
  }
}

############# crAPI #############
resource "aws_ecs_service" "crapi443_53" {
  count           = var.InsightAppSec_Module == true && var.use_route53_hz == true ? 1 : 0
  name            = "${var.Tenant}-crapi"
  cluster         = aws_ecs_cluster.webapps.id
  task_definition = one(aws_ecs_task_definition.crapi443[*].arn)
  launch_type     = "FARGATE"
  desired_count   = 1
  network_configuration {
    security_groups  = [var.ecs_service_sg_id]
    subnets          = [var.subnet_dmzwebapp1_id, var.subnet_dmzwebapp2_id]
    assign_public_ip = true
  }
  load_balancer {
    target_group_arn = one(aws_lb_target_group.crapi443[*].arn)
    container_name   = "${var.Tenant}-crapi443-task"
    container_port   = var.crAPI_Port_443
  }
  load_balancer {
    target_group_arn = one(aws_lb_target_group.crapi8025[*].arn)
    container_name   = "${var.Tenant}-crapi443-task"
    container_port   = var.crAPI_Port_8025
  }
  lifecycle {
    ignore_changes = [task_definition, desired_count]
  }
  depends_on = [var.aws_lb_listener_webapps443_id]
}

resource "aws_ecs_service" "crapi443" {
  count           = var.InsightAppSec_Module == true && var.use_route53_hz != true ? 1 : 0
  name            = "${var.Tenant}-crapi"
  cluster         = aws_ecs_cluster.webapps.id
  task_definition = one(aws_ecs_task_definition.crapi443[*].arn)
  launch_type     = "FARGATE"
  desired_count   = 1
  network_configuration {
    security_groups  = [var.ecs_service_sg_id]
    subnets          = [var.subnet_dmzwebapp1_id, var.subnet_dmzwebapp2_id]
    assign_public_ip = true
  }
  lifecycle {
    ignore_changes = [task_definition, desired_count]
  }
}

############# Jenkins #############
resource "aws_ecs_service" "jenkins_53" {
  count           = var.InsightAppSec_Module == true && var.use_route53_hz == true ? 1 : 0
  name            = "${var.Tenant}-jenkins"
  cluster         = aws_ecs_cluster.webapps.id
  task_definition = one(aws_ecs_task_definition.jenkins[*].arn)
  launch_type     = "FARGATE"
  desired_count   = 1
  network_configuration {
    security_groups  = [var.ecs_service_sg_id]
    subnets          = [var.subnet_dmzwebapp1_id, var.subnet_dmzwebapp2_id]
    assign_public_ip = true
  }
  load_balancer {
    target_group_arn = one(aws_lb_target_group.jenkins[*].arn)
    container_name   = "${var.Tenant}-jenkins-task"
    container_port   = var.Jenkins_Port
  }
  lifecycle {
    ignore_changes = [task_definition, desired_count]
  }
  depends_on = [var.aws_lb_listener_webapps443_id]
}

resource "aws_ecs_service" "jenkins" {
  count           = var.InsightAppSec_Module == true && var.use_route53_hz != true ? 1 : 0
  name            = "${var.Tenant}-jenkins"
  cluster         = aws_ecs_cluster.webapps.id
  task_definition = one(aws_ecs_task_definition.jenkins[*].arn)
  launch_type     = "FARGATE"
  desired_count   = 1
  network_configuration {
    security_groups  = [var.ecs_service_sg_id]
    subnets          = [var.subnet_dmzwebapp1_id, var.subnet_dmzwebapp2_id]
    assign_public_ip = true
  }
  lifecycle {
    ignore_changes = [task_definition, desired_count]
  }
}

############# PetClinic #############
resource "aws_ecs_service" "petclinic_53" {
  count           = var.InsightAppSec_Module == true && var.use_route53_hz == true ? 1 : 0
  name            = "${var.Tenant}-petclinic"
  cluster         = aws_ecs_cluster.webapps.id
  task_definition = one(aws_ecs_task_definition.petclinic[*].arn)
  launch_type     = "FARGATE"
  desired_count   = 1
  network_configuration {
    security_groups  = [var.ecs_service_sg_id]
    subnets          = [var.subnet_dmzwebapp1_id, var.subnet_dmzwebapp2_id]
    assign_public_ip = true
  }
  load_balancer {
    target_group_arn = one(aws_lb_target_group.petclinic[*].arn)
    container_name   = "${var.Tenant}-petclinic-task"
    container_port   = var.PetClinic_Port
  }
  lifecycle {
    ignore_changes = [task_definition, desired_count]
  }
  depends_on = [var.aws_lb_listener_webapps443_id]
}

resource "aws_ecs_service" "petclinic" {
  count           = var.InsightAppSec_Module == true && var.use_route53_hz != true ? 1 : 0
  name            = "${var.Tenant}-petclinic"
  cluster         = aws_ecs_cluster.webapps.id
  task_definition = one(aws_ecs_task_definition.petclinic[*].arn)
  launch_type     = "FARGATE"
  desired_count   = 1
  network_configuration {
    security_groups  = [var.ecs_service_sg_id]
    subnets          = [var.subnet_dmzwebapp1_id, var.subnet_dmzwebapp2_id]
    assign_public_ip = true
  }
  lifecycle {
    ignore_changes = [task_definition, desired_count]
  }
}

#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
#  Tasks Definition                                                                                                                                                                                                   
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
############# Juice Shop #############
resource "aws_ecs_task_definition" "juiceshop" {
  count                    = var.InsightAppSec_Module == true ? 1 : 0
  execution_role_arn       = aws_iam_role.ecsTaskExecutionRole.arn
  family                   = "juiceshop"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE", "EC2"]
  cpu                      = var.Juice_Shop_CPU
  memory                   = var.Juice_Shop_Memory
  # provisioner "local-exec" {
  #   command               = "bash ${var.script_name} ${aws_ecr_repository.app_ecr_repo.repository_url}"
  #   working_dir           = path.module
  # }
  container_definitions = <<DEFINITION
  [
    {
      "name": "${var.Tenant}-juiceshop-task",
      "image": "${var.Juice_Shop_Image}",
      "essential": true,
      "portMappings": [
        {
          "protocol": "tcp",
          "containerPort": ${var.Juice_Shop_Port},
          "hostPort": ${var.Juice_Shop_Port}
        }
      ],
      "logConfiguration": {
          "logDriver": "awslogs",
          "options": {
            "awslogs-group": "${aws_cloudwatch_log_group.webapps.id}",
            "awslogs-region": "${var.AWS_Region}",
            "awslogs-stream-prefix": "juiceshop"
          }
        },
      "memory": ${var.Juice_Shop_Memory},
      "cpu": ${var.Juice_Shop_CPU}
    }
    
  ]
  DEFINITION
}

############# Log4j #############
resource "aws_ecs_task_definition" "log4j" {
  count                    = var.InsightAppSec_Module == true ? 1 : 0
  execution_role_arn       = aws_iam_role.ecsTaskExecutionRole.arn
  family                   = "log4j"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE", "EC2"]
  cpu                      = var.Log4j_CPU
  memory                   = var.Log4j_Memory
  # provisioner "local-exec" {
  #   command               = "bash ${var.script_name} ${aws_ecr_repository.app_ecr_repo.repository_url}"
  #   working_dir           = path.module
  # }
  container_definitions = <<DEFINITION
  [
    {
      "name": "${var.Tenant}-log4j-task",
      "image": "${var.Log4j_Image}",
      "essential": true,
      "portMappings": [
        {
          "protocol": "tcp",
          "containerPort": ${var.Log4j_Port},
          "hostPort": ${var.Log4j_Port}
        }
      ],
      "logConfiguration": {
          "logDriver": "awslogs",
          "options": {
            "awslogs-group": "${aws_cloudwatch_log_group.webapps.id}",
            "awslogs-region": "${var.AWS_Region}",
            "awslogs-stream-prefix": "log4j"
          }
        },
      "memory": ${var.Log4j_Memory},
      "cpu": ${var.Log4j_CPU}
    }
    
  ]
  DEFINITION
}

############# Hackazon #############
resource "aws_ecs_task_definition" "hackazon" {
  count                    = var.InsightAppSec_Module == true ? 1 : 0
  execution_role_arn       = aws_iam_role.ecsTaskExecutionRole.arn
  family                   = "hackazon"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE", "EC2"]
  cpu                      = var.Hackazon_CPU
  memory                   = var.Hackazon_Memory
  # provisioner "local-exec" {
  #   command               = "bash ${var.script_name} ${aws_ecr_repository.app_ecr_repo.repository_url}"
  #   working_dir           = path.module
  # }
  container_definitions = <<DEFINITION
  [
    {
      "name": "${var.Tenant}-hackazon-task",
      "image": "${var.Hackazon_Image}",
      "essential": true,
      "portMappings": [
        {
          "protocol": "tcp",
          "containerPort": ${var.Hackazon_Port},
          "hostPort": ${var.Hackazon_Port}
        }
      ],
      "logConfiguration": {
          "logDriver": "awslogs",
          "options": {
            "awslogs-group": "${aws_cloudwatch_log_group.webapps.id}",
            "awslogs-region": "${var.AWS_Region}",
            "awslogs-stream-prefix": "hackazon"
          }
        },
      "memory": ${var.Hackazon_Memory},
      "cpu": ${var.Hackazon_CPU}
    }
    
  ]
  DEFINITION
}

############# GraphQL #############
resource "aws_ecs_task_definition" "graphql" {
  count                    = var.InsightAppSec_Module == true ? 1 : 0
  execution_role_arn       = aws_iam_role.ecsTaskExecutionRole.arn
  family                   = "graphql"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE", "EC2"]
  cpu                      = var.GraphQL_CPU
  memory                   = var.GraphQL_Memory
  # provisioner "local-exec" {
  #   command               = "bash ${var.script_name} ${aws_ecr_repository.app_ecr_repo.repository_url}"
  #   working_dir           = path.module
  # }
  container_definitions = <<DEFINITION
  [
    {
      "name": "${var.Tenant}-graphql-task",
      "image": "${var.GraphQL_Image}",
      "essential": true,
      "environment": [
                {
                    "name": "WEB_HOST",
                    "value": "0.0.0.0"
                }
            ],
      "portMappings": [
        {
          "protocol": "tcp",
          "containerPort": ${var.GraphQL_Port},
          "hostPort": ${var.GraphQL_Port}
        }
      ],
      "logConfiguration": {
          "logDriver": "awslogs",
          "options": {
            "awslogs-group": "${aws_cloudwatch_log_group.webapps.id}",
            "awslogs-region": "${var.AWS_Region}",
            "awslogs-stream-prefix": "graphql"
          }
        },
      "memory": ${var.GraphQL_Memory},
      "cpu": ${var.GraphQL_CPU}
    }
    
  ]
  DEFINITION
}

############# crAPI #############
resource "aws_ecs_task_definition" "crapi443" {
  count                    = var.InsightAppSec_Module == true ? 1 : 0
  execution_role_arn       = aws_iam_role.ecsTaskExecutionRole.arn
  family                   = "crapi443"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE", "EC2"]
  cpu                      = var.crAPI_CPU
  memory                   = var.crAPI_Memory
  # provisioner "local-exec" {
  #   command               = "bash ${var.script_name} ${aws_ecr_repository.app_ecr_repo.repository_url}"
  #   working_dir           = path.module
  # }
  container_definitions = <<DEFINITION
  [
    {
      "name": "${var.Tenant}-crapi443-task",
      "image": "${var.crAPI_Image}",
      "essential": true,
      "environment": [
                {
                    "name": "WEB_HOST",
                    "value": "0.0.0.0"
                }
            ],
      "portMappings": [
        {
          "protocol": "tcp",
          "containerPort": ${var.crAPI_Port_8888},
          "hostPort": ${var.crAPI_Port_8888}
        },
        {
          "protocol": "tcp",
          "containerPort": ${var.crAPI_Port_443},
          "hostPort": ${var.crAPI_Port_443}
        },
        {
          "protocol": "tcp",
          "containerPort": ${var.crAPI_Port_8025},
          "hostPort": ${var.crAPI_Port_8025}
        }
      ],
      "logConfiguration": {
          "logDriver": "awslogs",
          "options": {
            "awslogs-group": "${aws_cloudwatch_log_group.webapps.id}",
            "awslogs-region": "${var.AWS_Region}",
            "awslogs-stream-prefix": "crapi"
          }
        },
      "memory": ${var.crAPI_Memory},
      "cpu": ${var.crAPI_CPU}
    }
    
  ]
  DEFINITION
}

############# Jenkins #############
resource "aws_ecs_task_definition" "jenkins" {
  execution_role_arn       = aws_iam_role.ecsTaskExecutionRole.arn
  family                   = "jenkins"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE", "EC2"]
  cpu                      = var.Jenkins_CPU
  memory                   = var.Jenkins_Memory
  # provisioner "local-exec" {
  #   command               = "bash ${var.script_name} ${aws_ecr_repository.app_ecr_repo.repository_url}"
  #   working_dir           = path.module
  # }
  container_definitions = <<DEFINITION
  [
    {
      "name": "${var.Tenant}-jenkins-task",
      "image": "${var.Jenkins_Image}",
      "essential": true,
      "environment": [
                {
                  "name": "WEB_HOST",
                  "value": "0.0.0.0"
                }
            ],
      "portMappings": [
        {
          "protocol": "tcp",
          "containerPort": ${var.Jenkins_Port},
          "hostPort": ${var.Jenkins_Port}
        }
      ],
      "logConfiguration": {
          "logDriver": "awslogs",
          "options": {
            "awslogs-group": "${aws_cloudwatch_log_group.webapps.id}",
            "awslogs-region": "${var.AWS_Region}",
            "awslogs-stream-prefix": "jenkins"
          }
        },
      "memory": ${var.Jenkins_Memory},
      "cpu": ${var.Jenkins_CPU}
    }
    
  ]
  DEFINITION
}

############# PetClinic #############
resource "aws_ecs_task_definition" "petclinic" {
  count                    = var.InsightAppSec_Module == true ? 1 : 0
  execution_role_arn       = aws_iam_role.ecsTaskExecutionRole.arn
  family                   = "petclinic"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE", "EC2"]
  cpu                      = var.PetClinic_CPU
  memory                   = var.PetClinic_Memory
  # provisioner "local-exec" {
  #   command               = "bash ${var.script_name} ${aws_ecr_repository.app_ecr_repo.repository_url}"
  #   working_dir           = path.module
  # }
  container_definitions = <<DEFINITION
  [
    {
      "name": "${var.Tenant}-petclinic-task",
      "image": "${var.PetClinic_Image}",
      "essential": true,
      "environment": [
                {
                  "name": "WEB_HOST",
                  "value": "0.0.0.0"
                }
            ],
      "portMappings": [
        {
          "protocol": "tcp",
          "containerPort": ${var.PetClinic_Port},
          "hostPort": ${var.PetClinic_Port}
        }
      ],
      "logConfiguration": {
          "logDriver": "awslogs",
          "options": {
            "awslogs-group": "${aws_cloudwatch_log_group.webapps.id}",
            "awslogs-region": "${var.AWS_Region}",
            "awslogs-stream-prefix": "petclinic"
          }
        },
      "memory": ${var.PetClinic_Memory},
      "cpu": ${var.PetClinic_CPU}
    }
    
  ]
  DEFINITION
}

#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
#  Route 53 Records                                                                                                                                                                                                  
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------#
############# Juice Shop #############
resource "aws_route53_record" "cname_route53_record_juiceshop" {
  count   = var.InsightAppSec_Module == true && var.use_route53_hz == true ? 1 : 0
  zone_id = var.Zone_ID
  name    = "juiceshop.${var.ZoneName}" # Replace with your subdomain, Note: not valid with "apex" domains, e.g. example.com
  type    = "A"
  alias {
    name                   = "dualstack.${var.aws_lb_alb_webapps_dnsname}"
    zone_id                = var.aws_lb_alb_webapps_zoneid
    evaluate_target_health = false
  }
}

############# Log4j #############
resource "aws_route53_record" "cname_route53_record_log4j" {
  count   = var.InsightAppSec_Module == true && var.use_route53_hz == true ? 1 : 0
  zone_id = var.Zone_ID
  name    = "log4j.${var.ZoneName}" # Replace with your subdomain, Note: not valid with "apex" domains, e.g. example.com
  type    = "A"
  alias {
    name                   = "dualstack.${var.aws_lb_alb_webapps_dnsname}"
    zone_id                = var.aws_lb_alb_webapps_zoneid
    evaluate_target_health = false
  }
}

############# Hackazon #############
resource "aws_route53_record" "cname_route53_record_hackazon" {
  count   = var.InsightAppSec_Module == true && var.use_route53_hz == true ? 1 : 0
  zone_id = var.Zone_ID
  name    = "hackazon.${var.ZoneName}" # Replace with your subdomain, Note: not valid with "apex" domains, e.g. example.com
  type    = "A"
  alias {
    name                   = "dualstack.${var.aws_lb_alb_webapps_dnsname}"
    zone_id                = var.aws_lb_alb_webapps_zoneid
    evaluate_target_health = false
  }
}

############# GraphQL #############
resource "aws_route53_record" "cname_route53_record_graphql" {
  count   = var.InsightAppSec_Module == true && var.use_route53_hz == true ? 1 : 0
  zone_id = var.Zone_ID
  name    = "graphql.${var.ZoneName}" # Replace with your subdomain, Note: not valid with "apex" domains, e.g. example.com
  type    = "A"
  alias {
    name                   = "dualstack.${var.aws_lb_alb_webapps_dnsname}"
    zone_id                = var.aws_lb_alb_webapps_zoneid
    evaluate_target_health = false
  }
}

############# crAPI #############
resource "aws_route53_record" "cname_route53_record_crapi" {
  count   = var.InsightAppSec_Module == true && var.use_route53_hz == true ? 1 : 0
  zone_id = var.Zone_ID
  name    = "crapi.${var.ZoneName}" # Replace with your subdomain, Note: not valid with "apex" domains, e.g. example.com
  type    = "A"
  alias {
    name                   = "dualstack.${var.aws_lb_alb_webapps_dnsname}"
    zone_id                = var.aws_lb_alb_webapps_zoneid
    evaluate_target_health = false
  }
}

############# Jenkins #############
resource "aws_route53_record" "cname_route53_record_jenkins" {
  count   = var.use_route53_hz == true ? 1 : 0
  zone_id = var.Zone_ID
  name    = "jenkins.${var.ZoneName}" # Replace with your subdomain, Note: not valid with "apex" domains, e.g. example.com
  type    = "A"
  alias {
    name                   = "dualstack.${var.aws_lb_alb_webapps_dnsname}"
    zone_id                = var.aws_lb_alb_webapps_zoneid
    evaluate_target_health = false
  }
}

############# PetClinic #############
resource "aws_route53_record" "cname_route53_record_petclinic" {
  count   = var.InsightAppSec_Module == true && var.use_route53_hz == true ? 1 : 0
  zone_id = var.Zone_ID
  name    = "petclinic.${var.ZoneName}" # Replace with your subdomain, Note: not valid with "apex" domains, e.g. example.com
  type    = "A"
  alias {
    name                   = "dualstack.${var.aws_lb_alb_webapps_dnsname}"
    zone_id                = var.aws_lb_alb_webapps_zoneid
    evaluate_target_health = false
  }
}
