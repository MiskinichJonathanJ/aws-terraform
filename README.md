# Terraform AWS Infrastructure - Cliente/Servidor

Este proyecto implementa Infraestructura como Código (IaC) utilizando Terraform para aprovisionar recursos en Amazon Web Services (AWS).
El objetivo es demostrar cómo diseñar y desplegar un entorno cliente-servidor realista con seguridad básica, pensado tanto para prácticas como para entornos productivos (con las limitaciones del plan gratuito de AWS).

# Arquitectura Implementada

## Los recursos creados son los siguientes:

- **VPC (Virtual Private Cloud)**
Red privada en AWS donde se alojan los recursos, con subnets públicas y privadas.

- **EC2 (Elastic Compute Cloud)**
Instancias configuradas como servidores de aplicación, donde se ejecutaría el backend.

- **RDS (Relational Database Service)**
Base de datos relacional (PostgreSQL/MySQL según configuración) para persistencia de datos.

- **Load Balancer (ELB/ALB)**
Balanceador de carga que distribuye el tráfico entrante entre las instancias EC2.

- **Security Groups**
Reglas de firewall para controlar accesos y garantizar la seguridad del sistema.

## 🛠️ Tecnologías Utilizadas

- Terraform
- AWS
- PostgreSQL (en RDS)
- Infraestructura como Código (IaC)

## ⚙️ Requisitos Previos

- Terraform instalado (v1.5+ recomendado).
- Cuenta de AWS con credenciales configuradas en ~/.aws/credentials o variables de entorno:
```bash
export AWS_ACCESS_KEY_ID="tu-access-key"
export AWS_SECRET_ACCESS_KEY="tu-secret-key"
```
- Configuración opcional de variables de Terraform en variables.tf.

## Despliegue

1. Inicializar Terraform:
```bash
terraform init
```
2. Ver plan de ejecución:
```bash
terraform plan
```
3. Aplicar los cambios:
```bash
terraform apply
```
(confirmar con yes)

4. Para destruir la infraestructura:
```bash
terraform destroy
```

## Seguridad y Limitaciones

- Este proyecto está configurado para uso demostrativo y educativo.
- Las configuraciones están adaptadas para el plan gratuito de AWS.
- En un entorno productivo se deben agregar:
  - Módulos de Terraform para reutilización.
  - Auto Scaling Groups (ASG).
  - Monitoreo con CloudWatch.
  - Encriptación de base de datos y secretos con AWS KMS / Secrets Manager.

## Próximos Pasos / Mejoras

- Implementar módulos de Terraform para separar VPC, EC2, RDS y Load Balancer.
- Añadir autoescalado y grupos de disponibilidad.
- Integrar CI/CD para despliegue automático con GitHub Actions.
-  Monitoreo avanzado con CloudWatch y alarmas.
