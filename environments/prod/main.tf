module "networking" {
  source               = "../../modules/Networking"
  azs_count            = var.azs_count
  environment          = var.environment
  allowed_environments = var.allowed_environments
  project_name         = var.project_name
  common_tags          = var.common_tags
}
module "security" {
  source = "../../modules/Security"

  #GLOBALES
  environment          = var.environment
  allowed_environments = var.allowed_environments
  project_name         = var.project_name
  common_tags          = var.common_tags

  #DEPENDENCIAS
  vpc_id_net = module.networking.vpc_net_id
}
module "database" {
  source = "../../modules/database"

  #GLOBALES
  db_backup_retention  = var.db_backup_retention
  environment          = var.environment
  instance_db_type     = var.instance_db_type
  project_name         = var.project_name
  allowed_environments = var.allowed_environments
  common_tags          = var.common_tags
  db_username          = var.db_username

  #DEPENDENCIAS
  subnets_private_ids     = module.networking.subnets_privates_ids
  vpc_security_groups_ids = [module.security.id_db_security_group]
}
module "compute" {
  source = "../../modules/Compute"

  #GLOBALES
  environment            = var.environment
  instance_type          = var.instance_type
  project_name           = var.project_name
  common_tags            = var.common_tags
  allowed_environments   = var.allowed_environments
  desired_size_instances = var.desired_size_instances
  max_size_instances     = var.max_size_instances
  min_size_instances     = var.min_size_instances

  #DEPENDENCIAS
  security_groups_app_id = module.security.id_app_security_group
  security_groups_lb_id  = module.security.id_web_security_group
  subnet_id_privates     = module.networking.subnets_privates_ids
  subnets_publics_ids    = module.networking.subnets_public_ids
  vpc_id_net             = module.networking.vpc_net_id
}
