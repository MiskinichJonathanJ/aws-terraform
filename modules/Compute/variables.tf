###### INSTANCIAS EC2 #################
variable "instance_type" {
  type        = string                     # The type of the variable, in this case a string
  default     = "t3.micro"                 # Default value for the variable
  description = "The type of EC2 instance" # Description of what this variable represents

  validation {
    condition     = contains(["t3.micro", "t3.small"], var.instance_type) #Solo  instancias  del plan gratuito
    error_message = "Solo se permiten instancias del plan  gratuito: t3.micro, t3.small"
  }
}
variable "max_size_instances" {
  type        = number
  description = "Numero de instancias maximas a tener en la Infraestructura"
  default     = 2

  validation {
    condition     = var.max_size_instances >= 1
    error_message = "El maximo de instancias debe ser mayor o  igual a 1"
  }
}
variable "min_size_instances" {
  type        = number
  description = "Numero de instancias minimas a tener en la Infraestructura"
  default     = 1

  validation {
    condition     = var.min_size_instances >= 1
    error_message = "El minimo de instancias debe ser mayor o  igual a 1"
  }
}
variable "desired_size_instances" {
  type        = number
  description = "Numero de instancias maximas a tener en la Infraestructura"
  default     = 1

  validation {
    condition     = var.desired_size_instances >= 1
    error_message = "El ideal de instancias debe ser mayor o  igual a 1"
  }
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

