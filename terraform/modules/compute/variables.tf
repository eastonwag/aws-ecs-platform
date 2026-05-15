variable "project_name" {}
variable "aws_region" {}
variable "aws_account_id" {}
variable "public_subnet_ids" { type = list(string) }
variable "ecs_sg_id" {}
variable "db_host" {}
variable "target_group_arn" {}