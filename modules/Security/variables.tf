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
  description = "Nombre para el proyecto actual. (Global)"
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
################################