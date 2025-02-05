resource "aws_db_instance" "app_db" {
  identifier             = "wordpress-db"
  allocated_storage      = 10
  db_name                = "metrodb"
  engine                 = "mysql"
  engine_version         = "8.0"
  instance_class         = "db.t3.micro"
  username               = "admin"
  password               = "Metro123456"
  parameter_group_name   = "default.mysql8.0"
  skip_final_snapshot    = true
  db_subnet_group_name   = aws_db_subnet_group.rds_subnet_group.id
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
}

resource "aws_lb" "wordpress_alb" {
  name               = "Wordpress-ALB"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = [aws_subnet.public_subnet1.id, aws_subnet.public_subnet2.id]
}

resource "aws_lb_target_group" "wordpress_tg" {
  name     = "Wordpress-ALB-TG"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.custom_vpc.id
}

resource "aws_lb_listener" "wordpress_lisener" {
  load_balancer_arn = aws_lb.wordpress_alb.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.wordpress_tg.arn
  }
}

resource "aws_launch_template" "instance_template" {
  name                   = "Wordpress-Launch-Template"
  image_id               = var.ec2_ami
  instance_type          = var.ec2_instance_type
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]
  user_data = base64encode(templatefile("${path.module}/userdata.sh.tpl", {
    db_endpoint = aws_db_instance.app_db.address,
    username    = "admin"
    password    = "Metro123456"
    dbname      = "metrodb"
  }))
}

resource "aws_autoscaling_group" "wordpress_autoscaling" {
  desired_capacity  = 2
  max_size          = 10
  min_size          = 2
  name              = "Wordpress-ASG"
  health_check_type = "EC2"
  launch_template {
    id      = aws_launch_template.instance_template.id
    version = "$Latest"
  }
  target_group_arns   = [aws_lb_target_group.wordpress_tg.arn]
  vpc_zone_identifier = [aws_subnet.private_subnet1.id, aws_subnet.private_subnet2.id]
}

resource "aws_autoscaling_policy" "wordpress_scaling_policy" {
  autoscaling_group_name = aws_autoscaling_group.wordpress_autoscaling.name
  name                   = "Scaling_Policy"
  policy_type            = "TargetTrackingScaling"
  target_tracking_configuration {
    target_value = 60
    customized_metric_specification {
      metrics {
        id = "scaling"
        metric_stat {
          metric {
            namespace   = "AWS/EC2"
            metric_name = "CPUUtilization"
            dimensions {
              name  = "AutoScalingGroupName"
              value = "my-asg"
            }
          }
          stat = "Average"
        }
      }
    }
  }
}