variable "instance_type" {
  type        = string                     # The type of the variable, in this case a string
  default     = "t3.micro"                 # Default value for the variable
  description = "The type of EC2 instance" # Description of what this variable represents

  validation {
    condition     = contains(["t3.micro", "t3.small"], var.instance_type) #Solo  instancias  del plan gratuito
    error_message = "Solo se permiten instancias del plan  gratuito: t3.micro, t3.small"
  }
}

variable "region" {
  type        = string
  description = "Region a ejecutar los servicios de AWS"
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

variable "cidr_vpc" {
  type        = string
  description = "Rango  de  direcciones IP para la VPC"
  default     = "10.0.0.0/16"

  validation {
    condition     = can(cidrhost(var.cidr_vpc, 0))
    error_message = "Debe proporcionar un rango  de  IP valido. (ejemplo: 10.0.0.0/16)"
  }
}


variable "azs_count" {
  type        = number
  description = "Cantidad de AZ para ejecutar los servicios."
  default     = 2

  validation {
    condition     = var.azs_count >= 1 && var.azs_count < 4
    error_message = "Las cantidad de AZ debe ser mayor  o  igual a 1 o  menor a 4" #Mas de 4 AZ costos sin sentidos.
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

variable "allowed_cidr_blocks" {
  type        = list(string)
  description = "Bloques de CIDR para el  trafico HTTP/HTTPS"
  default     = ["0.0.0.0/0"]

  validation {
    condition = alltrue(
      [for cidr in var.allowed_cidr_blocks : can(cidrhost(cidr, 0))]
    )
    error_message = "El bloque de CIDR  debe ser valido"
  }
}

variable "db_backup_retention" {
  type        = number
  description = "Numero de dias que se retiene el  backup  en la base de  datos"
  default     = 7

  validation {
    condition     = var.db_backup_retention >= 1 && var.db_backup_retention <= 30
    error_message = "El periodo de  retencion debe  ser  entre  1  y 30 dias"
  }
}

variable "common_tags" {
  type        = map(string)
  description = "Tags comunes aplicados a todos los recursos"
  default     = {}
}

variable "enable_deletion_protection" {
  type        = bool
  description = "Habilitar protección contra eliminación para recursos críticos"
  default     = false
}

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

variable "instance_db_type" {
  type        = string
  description = "Tipo de instancia de la base de datos"
  default     = "db.t3.micro"

  validation {
    condition     = contains(["db.t3.micro", "db.t4g.micro"], var.instance_db_type)
    error_message = "Solo se permiten instancias del plan  gratuito: db.t3.micro  o db.t4g.micro"
  }
}

variable "db_username" {
  type        = string
  description = "Nombre de usuario de la DB"
  default     = "dbadmin"
}