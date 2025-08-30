########### CIDRs ##################
variable "cidr_vpc" {
  type        = string
  description = "Rango  de  direcciones IP para la VPC"
  default     = "10.0.0.0/16"

  validation {
    condition     = can(cidrhost(var.cidr_vpc, 0))
    error_message = "Debe proporcionar un rango  de  IP valido. (ejemplo: 10.0.0.0/16)"
  }
}
variable "private_subnets_cidr" {
  type        = list(string)
  description = "CIDRs para subnets privadas"
  default     = ["10.0.1.0/24", "10.0.2.0/24"]

  validation {
    condition     = alltrue([for cidr in var.private_subnets_cidr : can(cidrhost(cidr, 0))])
    error_message = "Todos los CIDRs deben ser validos"
  }
}
variable "public_subnets_cidr" {
  type        = list(string)
  description = "CIDRs para  subnets publicas"
  default     = ["10.0.3.0/24", "10.0.4.0/24"]

  validation {
    condition     = alltrue([for cidr in var.public_subnets_cidr : can(cidrhost(cidr, 0))])
    error_message = "Todos los CIDRs deben ser validos"
  }
}
########## GATEWAY Y NAT ################
variable "enable_nat_gateway" {
  type        = bool
  description = "Habilitar NAT Gateway para conectividad saliente desde subnets privadas"
  default     = true
}

variable "single_nat_gateway" {
  type        = bool
  description = "Usar un solo NAT Gateway (reduce costos pero elimina redundancia)"
  default     = false

  validation {
    condition     = !var.single_nat_gateway || var.enable_nat_gateway
    error_message = "single_nat_gateway requiere que enable_nat_gateway sea true"
  }
}
########## REGION Y AZS #################
variable "azs_count" {
  type        = number
  description = "Cantidad de AZ para ejecutar los servicios."
  default     = 2

  validation {
    condition     = var.azs_count >= 1 && var.azs_count < 4
    error_message = "Las cantidad de AZ debe ser mayor  o  igual a 1 o  menor a 4" #Mas de 4 AZ costos sin sentidos.
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
variable "project_name" {
  type        = string
  description = "Nombre para el proyecto actual."

  validation {
    condition     = can(regex("^[a-z][a-z0-9-]*[a-z0-9]$", var.project_name))
    error_message = "El nombre del proyecto debe ser lowercase,  empezar y terminar con letra."
  }
}