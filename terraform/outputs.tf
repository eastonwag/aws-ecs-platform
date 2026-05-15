output "networking_vpc_id" {
  value = module.networking.vpc_id
}

output "alb_sg_id" {
  value = module.security.alb_sg_id
}

output "ecr_repository_url" {
  value = module.compute.ecr_repository_url
}

output "ecs_cluster_name" {
  value = module.compute.ecs_cluster_name
}

output "ecs_service_name" {
  value = module.compute.ecs_service_name
}

output "alb_dns_name" {
  value = module.alb.alb_dns_name
}