output "vpc_net_id" {
  value = module.vpc.vpc_id
  description = "ID de la vpc de la red de la nube"
}
output "subnets_privates_ids" {
  value = module.vpc.private_subnets
  description = "Lista de IDs  de las subnets privadas"
}
output "subnets_public_ids" {
  value = module.vpc.private_subnets
  description = "Lista de IDs  de las subnets publicas"
}