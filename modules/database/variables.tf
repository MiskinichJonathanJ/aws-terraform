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

variable "db_username" {
  type        = string
  description = "Nombre de usuario de la DB"
  sensitive = true
}
variable "subnets_private_ids" {
  type        = list(string)
  description = "CIDRs de las subnets privadas"
  validation {
    condition     = length(var.subnets_private_ids) > 0
    error_message = "Debe proporcionar al menos un ID de subnet privada"
  }
}
variable "db_backup_retention" {
  type        = number
  description = "Numero en dias para la retencion del backup"
}
variable "vpc_security_groups_ids" {
  type        = list(string)
  description = "Grupos de seguridad para la DB"
}
variable "instance_db_type" {
  type        = string
  description = "Tipo de instancia de la base de datos"
}
