variable "project_name" {
  type        = string
  description = "Nombre del proyecto"

  validation {
    condition     = can(regex("^[a-z][a-z0-9-]*[a-z0-9]$", var.project_name))
    error_message = "El nombre del proyecto debe ser lowercase,  empezar y terminar con letra."
  }
}

########################################
# VARIABLES PARA  EL NOMBRE  DEL ENTORNO
variable "allowed_environments" {
  type        = list(string)
  description = "Tipos de entornos  validos"
  default     = ["dev", "stagging", "prod"]

  validation {
    condition     = length(var.allowed_environments) > 0 && length(var.allowed_environments) <= 10
    error_message = "La  cantidad  de entornor  debe  ser entre 1 y 10"
  }
}

variable "environment" {
  type        = string
  description = "Entorno de despliegue (dev, stagging, prod)"
  default     = "dev"

  validation {
    condition     = contains(var.allowed_environments, var.environment)
    error_message = "Environment debe ser uno definidos en allowed_environments"
  }
}
############################
#VARIABLES PARA  LAS TAGS  #
############################
variable "common_tags" {
  type        = map(string)
  description = "Tags comunes aplicados a todos los recursos"
  default     = {}
}
##############################

variable "db_username" {
  type        = string
  description = "Nombre de usuario de la DB"
  default     = "dbadmin"
}

variable "subnets_private_ids" {
  type        = list(string)
  description = "CIDRs de las subnets privadas"

  validation {
    condition = alltrue([
      for cidr in var.subnets_private_ids : can(cidrhost(cidr, 0))
    ])
    error_message = "Debe proporcionar un CIDR valido"
  }
}

variable "db_backup_retention" {
  type        = number
  description = "Numero en dias para la retencion del backup"
  default     = 7

  validation {
    condition     = var.db_backup_retention >= 1 && var.db_backup_retention <= 30
    error_message = "El numero de dias debe estar entre  1 y 30"
  }
}

variable "vpc_security_groups_ids" {
  type        = list(string)
  description = "Grupos de seguridad para la DB"
}

variable "instance_db_type" {
  type        = string
  description = "Tipo de instancia de la base de datos"
  default     = "db.t3.micro"

  validation {
    condition     = contains(["db.t3.micro", "db.t4g.micro"], var.instance_db_type)
    error_message = "Solo se permiten instancias del plan  gratuito: db.t3.micro  o db.t4g.micro"
  }
}
