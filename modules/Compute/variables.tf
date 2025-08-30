###### INSTANCIAS EC2 #################
variable "instance_type" {
  type        = string                     # The type of the variable, in this case a string
  description = "The type of EC2 instance"
}
variable "max_size_instances" {
  type        = number
  description = "Numero de instancias maximas a tener en la Infraestructura"
}
variable "min_size_instances" {
  type        = number
  description = "Numero de instancias minimas a tener en la Infraestructura"
}
variable "desired_size_instances" {
  type        = number
  description = "Numero de instancias maximas a tener en la Infraestructura"
}
######## SECURITY GROUPS ###################
variable "security_groups_app_id" {
  type        = string
  description = "Grupos de seguridad para las instancias EC2"
}
variable "security_groups_lb_id" {
  type        = string
  description = "Grupos de seguridad para el LB"
}
##### VPC Y SUBNETS ##########
variable "vpc_id_net" {
  type        = string
  description = "Id  de la VPC de la Nube"
}
variable "subnet_id_privates" {
  type        = list(string)
  description = "Id de la subnets privadas"
}
variable "subnets_publics_ids" {
  type        = list(string)
  description = "Id de la Subnets publicas"
}
###### GLOBALES #############
variable "project_name" {
  type        = string
  description = "Nombre del proyecto (Global)"
}
variable "allowed_environments" {
  type        = list(string)
  description = "Tipos de entornos  validos (Global)"
}
variable "environment" {
  type        = string
  description = "Entorno de despliegue (dev, stagging, prod) (Global)"
}
variable "common_tags" {
  type        = map(string)
  description = "Tags comunes aplicados a todos los recursos (Global)"
}