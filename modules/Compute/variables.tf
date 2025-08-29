variable "instance_type" {
  type        = string                     # The type of the variable, in this case a string
  default     = "t2.micro"                 # Default value for the variable
  description = "The type of EC2 instance" # Description of what this variable represents
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

variable "security_groups_app_id" {
  type        = string
  description = "Grupos de seguridad para las instancias EC2"
}

variable "security_groups_lb_id" {
  type        = string
  description = "Grupos de seguridad para el LB"
}

variable "subnets_publics_lb_id" {
  type        = string
  description = "Id de la Subnet publica para el Load Balance"
}

variable "vpc_id_net" {
  type        = string
  description = "Id  de la VPC de la Nube"
}

variable "subnet_id_instances_ec2" {
  type        = string
  description = "Id de la subnet privada para las Instancias EC2"
}
