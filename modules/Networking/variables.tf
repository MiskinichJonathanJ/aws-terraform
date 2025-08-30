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
########## GLOBAL #################
variable "azs_count" {
  type        = number
  description = "Cantidad de AZ para ejecutar los servicios.(Global)"
}
variable "allowed_environments" {
  type        = list(string)
  description = "Tipos de entornos  validos (Global)"
}
variable "environment" {
  type        = string
  description = "Entorno de despliegue (Global)"
}
variable "project_name" {
  type        = string
  description = "Nombre para el proyecto actual.(Global)"
}