variable "instance_type" {
  type        = string                     # The type of the variable, in this case a string
  default     = "t3.micro"                 # Default value for the variable
  description = "The type of EC2 instance" # Description of what this variable represents
}

variable "region" {
  type        = string
  description = "Region a ejecutar los servicios de AWS"
}

variable "allowed_environments" {
  type = list(string)
  description = "Tipos de entornos  validos"
  default = ["dev", "stagging", "prod"]

  validation {
    condition = var.allowed_environments.names >0 && var.allowed_environments.names <=  10
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

variable "cidr_vpc" {
  type        = string
  description = "Rango  de  direcciones IP para la VPC"
  default     = "10.0.0.0/16"

  validation {
    condition = can(cidrhost(var.cidr_vpc, 0))
    error_message = "Debe proporcionar un rango  de  IP valido. (ejemplo: 10.0.0.0/16)"
  }
}


variable "azs_count" {
  type        = number
  description = "Cantidad de AZ para ejecutar los servicios."
  default = 2

  validation {
    condition = var.azs_count >= 1 && var.azs_count < 4
    error_message = "Las cantidad de AZ debe ser mayor  o  igual a 1 o  menor a 4" #Mas de 4 AZ costos sin sentidos.
  }
}

variable "project_name" {
  type = string
  description = "Nombre para el proyecto actual."
}