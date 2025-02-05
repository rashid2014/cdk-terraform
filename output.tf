output "vpc_id" {
  value = aws_vpc.custom_vpc.id
}

output "public_subnet1_id" {
  value = aws_subnet.public_subnet1.id
}

output "private_subnet1_id" {
  value = aws_subnet.private_subnet1.id
}

output "public_subnet2_id" {
  value = aws_subnet.public_subnet2.id
}

output "private_subnet2_id" {
  value = aws_subnet.private_subnet2.id
}

output "alb_sg_id" {
  value = aws_security_group.alb_sg.id
}

output "ec2_sg_id" {
  value = aws_security_group.ec2_sg.id
}

output "rds_sg_id" {
  value = aws_security_group.rds_sg.id
}

output "rds_subnetgroup_id" {
  value = aws_db_subnet_group.rds_subnet_group.id
}

output "rds_db_endpoint" {
  value = aws_db_instance.app_db.endpoint
}

output "alb_dns_name" {
  value = aws_lb.wordpress_alb.dns_name
}

output "alb_tg_arn" {
  value = aws_lb_target_group.wordpress_tg.arn
}