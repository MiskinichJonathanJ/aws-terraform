########## REGLAS GRUPOS ##################
variable "allowed_cidr_blocks_http" {
  type = string
  description = "Bloques de CIDR para el  trafico HTTP/HTTPS"
  default     = "0.0.0.0/0"

  validation {
    condition = can(cidrhost(var.allowed_cidr_blocks_http, 0))
    error_message = "El bloque de CIDR  debe ser valido"
  }
}

##### VPC Y SUBNETS ##########
variable "vpc_id_net" {
  type        = string
  description = "Id  de la VPC de la Nube"
}

##################################
variable "project_name" {
  type        = string
  description = "Nombre para el proyecto actual."

  validation {
    condition     = can(regex("^[a-z][a-z0-9-]*[a-z0-9]$", var.project_name))
    error_message = "El nombre del proyecto debe ser lowercase,  empezar y terminar con letra."
  }
}

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

variable "common_tags" {
  type        = map(string)
  description = "Tags comunes aplicados a todos los recursos"
  default     = {}
}
################################