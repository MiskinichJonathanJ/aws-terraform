# Infraestructura AWS como Código con Terraform

[![Terraform](https://img.shields.io/badge/Terraform-v1.5+-623CE4?logo=terraform)](https://www.terraform.io/)
[![AWS](https://img.shields.io/badge/AWS-Cloud-FF9900?logo=amazon-aws)](https://aws.amazon.com/)
[![Infrastructure](https://img.shields.io/badge/Infrastructure-as%20Code-blue)]()
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

## 🎯 Resumen del Proyecto

Este proyecto demuestra una **infraestructura AWS de nivel productivo y multi-ambiente** construida usando **Terraform** y siguiendo las **mejores prácticas de Infrastructure as Code (IaC)**. Exhibe el diseño e implementación de una arquitectura de tres capas escalable y segura, adecuada para aplicaciones web modernas.

La infraestructura implementa una **arquitectura cliente-servidor completa** con capas de seguridad apropiadas, gestión de base de datos, balanceo de carga y capacidades de auto-escalado, todo manteniendo la rentabilidad a través de la selección de recursos del Free Tier de AWS.

## 🏗️ Arquitectura

### Componentes de Infraestructura

El proyecto implementa una **arquitectura de tres capas** siguiendo los principios del AWS Well-Architected Framework:

**Capa de Presentación (Web Layer)**
- Application Load Balancer (ALB) para distribución de tráfico y alta disponibilidad
- Subnets públicas distribuidas en múltiples Availability Zones para redundancia
- Security groups con acceso controlado HTTP/HTTPS desde internet

**Capa de Aplicación (App Layer)**
- Auto Scaling Group con instancias EC2 ejecutándose en subnets privadas
- Launch templates con user data para configuración automatizada del servidor web Apache
- Políticas de escalado configurables para manejar cargas variables de tráfico

**Capa de Datos (Database Layer)**
- Instancia Amazon RDS MySQL con despliegue Multi-AZ para alta disponibilidad
- Database subnet group distribuido en múltiples subnets privadas
- Integración con AWS Secrets Manager para gestión segura de credenciales
- Configuración de backup automatizado con períodos de retención personalizables

### Arquitectura de Red

La base de networking proporciona aislamiento seguro y flujo de tráfico apropiado:

- **VPC** con bloque CIDR personalizado y resolución DNS habilitada
- **Subnets Públicas** para load balancer y componentes con acceso a internet
- **Subnets Privadas** para servidores de aplicación e instancias de base de datos
- **NAT Gateways** para acceso seguro de salida a internet desde recursos privados
- **Internet Gateway** para conectividad a internet de subnets públicas
- **Route Tables** con reglas de enrutamiento apropiadas para cada tier de subnet

## 🚀 Características Principales

### Gestión de Ambientes
- **Estructura multi-ambiente** soportando desarrollo, staging y producción
- **Configuraciones específicas por ambiente** con gestión aislada del state de Terraform
- **Nomenclatura consistente de recursos** y etiquetado a través de todos los ambientes
- **Arquitectura escalable** que puede ser fácilmente replicada a través de regiones AWS

### Implementación de Seguridad
- **Defensa en profundidad** con múltiples capas de security groups
- **Principio de menor privilegio** aplicado a todas las reglas de security groups
- **Cifrado de credenciales de base de datos** usando AWS Secrets Manager
- **Aislamiento de red** con subnets privadas para componentes sensibles
- **Reglas de security groups** siguiendo las mejores prácticas de seguridad de AWS

### Excelencia Operacional
- **Infrastructure as Code** con control de versiones y seguimiento de cambios
- **Diseño modular** para reutilización de código y mantenibilidad
- **Etiquetado automatizado de recursos** para asignación de costos y gestión de recursos
- **Validación de inputs** para todas las variables de Terraform para prevenir errores de configuración

## 📁 Estructura del Proyecto

```
terraform-aws-infrastructure/
├── environments/                    # Configuraciones específicas por ambiente
│   ├── dev/                        # Ambiente de desarrollo
│   │   ├── main.tf                 # Definiciones de recursos del ambiente dev
│   │   ├── variables.tf            # Declaraciones de variables específicas de dev
│   │   ├── terraform.tfvars        # Valores de variables del ambiente dev
│   │   └── outputs.tf              # Outputs del ambiente dev
│   ├── staging/                    # Ambiente de staging (pre-producción)
│   └── prod/                       # Ambiente de producción
│
├── modules/                        # Módulos reutilizables de Terraform
│   ├── Networking/                 # VPC, subnets, gateways, routing
│   │   ├── main.tf                # Recursos de infraestructura de red
│   │   ├── variables.tf           # Variables de configuración de red
│   │   └── outputs.tf             # Outputs de recursos de red
│   ├── Security/                   # Security groups y reglas
│   │   ├── main.tf                # Definiciones de security groups
│   │   ├── variables.tf           # Variables de configuración de seguridad
│   │   └── outputs.tf             # IDs de security groups y referencias
│   ├── Compute/                    # EC2, Auto Scaling, Load Balancer
│   │   ├── main.tf                # Recursos de infraestructura de cómputo
│   │   ├── variables.tf           # Variables de configuración de cómputo
│   │   ├── outputs.tf             # Outputs de load balancer e instancias
│   │   └── User-data.tf           # Data source de AMI para instancias EC2
│   └── database/                   # RDS y recursos relacionados
│       ├── main.tf                # Infraestructura de base de datos
│       ├── variables.tf           # Variables de configuración de BD
│       └── outputs.tf             # Información de conexión a base de datos
│
├── main.tf.example                 # Archivo de configuración principal de ejemplo
├── variables.tf.example            # Declaraciones de variables de ejemplo
├── terraform.tf                    # Restricciones de provider y versión
└── README.md                       # Documentación del proyecto
```

## 🛠️ Tecnologías y Herramientas

- **Terraform**: Framework de Infrastructure as Code para aprovisionamiento de recursos AWS
- **Amazon Web Services (AWS)**: Plataforma cloud proporcionando servicios de infraestructura escalables
- **Amazon VPC**: Ambiente de red aislado con direccionamiento IP personalizado
- **Amazon EC2**: Instancias de cómputo virtuales escalables con capacidades de Auto Scaling
- **Amazon RDS**: Servicio de base de datos relacional gestionado con motor MySQL
- **Application Load Balancer**: Balanceo de carga Layer 7 con health checks
- **AWS Secrets Manager**: Almacenamiento seguro y rotación de credenciales de base de datos
- **Apache HTTP Server**: Servidor web configurado automáticamente vía scripts de user data

## ⚙️ Requisitos Previos

Antes de desplegar esta infraestructura, asegúrate de cumplir con los siguientes requisitos:

**Configuración del Ambiente Local**
- Terraform instalado (versión 1.5 o superior recomendada para las últimas características)
- AWS CLI configurado con credenciales apropiadas y región por defecto
- Git para control de versiones y gestión del repositorio

**Configuración de Cuenta AWS**
- Cuenta AWS activa con acceso programático habilitado
- Usuario o rol IAM con permisos suficientes para creación de recursos
- Credenciales AWS configuradas vía uno de estos métodos:
  - Archivo de credenciales AWS (`~/.aws/credentials`)
  - Variables de ambiente (`AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`)
  - Roles IAM (cuando se ejecuta desde EC2 u otros servicios AWS)

**Permisos AWS Requeridos**
El despliegue requiere permisos para gestionar estos servicios AWS:
- VPC y componentes de networking (subnets, route tables, gateways)
- Instancias EC2, launch templates y Auto Scaling groups
- Instancias RDS y database subnet groups
- Application Load Balancer y target groups
- Security groups y reglas de security groups
- Secrets Manager para almacenamiento de credenciales de base de datos

## 🚀 Instrucciones de Despliegue

### Despliegue del Ambiente de Desarrollo

Navega al directorio del ambiente de desarrollo e inicializa Terraform:

```bash
cd environments/dev
terraform init
```

Crea un archivo `terraform.tfvars` con tu configuración específica:

```hcl
# Configuración del Proyecto
project_name = "nombre-de-tu-proyecto"
environment = "dev"

# Configuración de Instancias
instance_type = "t3.micro"
instance_db_type = "db.t3.micro"

# Configuración de Auto Scaling
desired_size_instances = 2
min_size_instances = 1
max_size_instances = 4

# Configuración de Infraestructura
azs_count = 2
db_backup_retention = 7
db_username = "dbadmin"

# Etiquetado de Recursos
common_tags = {
  Owner = "Tu-Nombre"
  Project = "AWS-Infrastructure-Demo"
  Environment = "Development"
}
```

Revisa los cambios planeados en la infraestructura:

```bash
terraform plan
```

Despliega la infraestructura:

```bash
terraform apply
```

Cuando se te solicite, escribe `yes` para confirmar el despliegue.

### Despliegue del Ambiente de Producción

Para el despliegue de producción, navega al ambiente de producción:

```bash
cd environments/prod
```

Sigue el mismo proceso de inicialización y despliegue, pero con valores apropiados para producción en tu `terraform.tfvars`:

```hcl
# Producción típicamente usa instancias más grandes y mayor disponibilidad
desired_size_instances = 4
min_size_instances = 2
max_size_instances = 8
azs_count = 3
db_backup_retention = 30
```

### Limpieza de Infraestructura

Para evitar cargos continuos de AWS, destruye la infraestructura cuando ya no sea necesaria:

```bash
terraform destroy
```

**Importante**: Siempre ejecuta `terraform destroy` en ambientes de prueba para prevenir cargos inesperados.

## 📊 Configuraciones de Ambientes

### Ambiente de Desarrollo
- **Propósito**: Desarrollo y pruebas con uso mínimo de recursos
- **Tipos de Instancia**: t3.micro para optimización de costos
- **Escalado**: 1-4 instancias con capacidad deseada de 2
- **Availability Zones**: 2 AZs para redundancia básica
- **Backup de Base de Datos**: Retención de 7 días para necesidades de desarrollo

### Ambiente de Staging
- **Propósito**: Pruebas de pre-producción y validación
- **Tipos de Instancia**: t3.small para pruebas realistas de rendimiento
- **Escalado**: 2-6 instancias con capacidad deseada de 3
- **Availability Zones**: 2-3 AZs para configuración similar a producción
- **Backup de Base de Datos**: Retención de 14 días para ciclos de prueba extendidos

### Ambiente de Producción
- **Propósito**: Hosting de aplicación en vivo con alta disponibilidad
- **Tipos de Instancia**: Optimizadas para cargas de trabajo de producción dentro de restricciones del free tier
- **Escalado**: 2-8 instancias con capacidad deseada de 4
- **Availability Zones**: 3 AZs para máxima disponibilidad
- **Backup de Base de Datos**: Retención de 30 días para cumplimiento y necesidades de recuperación

## 🔒 Características de Seguridad

### Seguridad de Red
- **Aislamiento de subnet privada** asegura que las capas de aplicación y base de datos no sean directamente accesibles desde internet
- **Capas de security groups** implementa defensa en profundidad con reglas específicas para cada capa
- **Configuración de NAT Gateway** proporciona acceso seguro de salida a internet para recursos privados

### Protección de Datos
- **Cifrado de RDS en reposo** usando llaves de cifrado gestionadas por AWS
- **Gestión de credenciales de base de datos** a través de AWS Secrets Manager con capacidad de rotación automática
- **Capacidad de VPC flow logs** para monitoreo de tráfico de red y análisis de seguridad

### Control de Acceso
- **Principio de menor privilegio** aplicado a todas las reglas de security groups
- **Controles de acceso específicos por puerto** limitando comunicación solo a protocolos requeridos
- **Restricciones basadas en origen** asegurando que el tráfico fluya solo entre capas apropiadas

## 📈 Escalabilidad y Rendimiento

### Configuración de Auto Scaling
- **Políticas de escalado dinámico** basadas en utilización de CPU y carga de aplicación
- **Despliegue en múltiples Availability Zones** para alta disponibilidad y tolerancia a fallos
- **Health checks del load balancer** asegurando que el tráfico se enrute solo a instancias saludables

### Rendimiento de Base de Datos
- **Despliegue Multi-AZ de RDS** para failover automatizado y disponibilidad mejorada
- **Soporte para connection pooling** a través de configuración en la capa de aplicación
- **Ventanas de backup y mantenimiento** programadas durante períodos de bajo uso

## 💰 Optimización de Costos

Este proyecto está diseñado con conciencia de costos mientras mantiene preparación para producción:

### Utilización del AWS Free Tier
- **Instancias EC2 t3.micro** incluidas en la asignación del free tier
- **Instancias de base de datos RDS db.t3.micro** para pruebas rentables
- **Application Load Balancer** con costos mínimos de transferencia de datos
- **Componentes de VPC y networking** incluidos en la asignación base del free tier

### Right-Sizing de Recursos
- **Dimensionamiento específico por ambiente** asegura que desarrollo use recursos mínimos
- **Límites de Auto Scaling** previenen costos desbocados por tráfico inesperado
- **Políticas de escalado programado** pueden implementarse para patrones de carga predecibles

## 🔧 Opciones de Personalización

### Configuración de Variables
La infraestructura soporta personalización extensiva a través de variables de Terraform:

- **Bloques CIDR de red** pueden modificarse para diferentes esquemas de direccionamiento IP
- **Tipos y tamaños de instancia** pueden ajustarse basados en requisitos de rendimiento
- **Parámetros de Auto Scaling** pueden afinarse para patrones específicos de carga de aplicación
- **Configuración de base de datos** soporta diferentes motores y parameter groups

### Extensión de Módulos
El diseño modular permite extensión y modificación fácil:

- **Reglas de seguridad adicionales** pueden agregarse a security groups existentes
- **Módulos de monitoreo y alertas** pueden integrarse con infraestructura existente
- **Componentes de backup y disaster recovery** pueden agregarse para mejorar protección de datos

## 🎯 Competencias Profesionales Demostradas

### Expertise en Infrastructure as Code
- **Desarrollo de módulos de Terraform** con validación de input apropiada y gestión de outputs
- **Mejores prácticas de gestión de state** con aislamiento de ambientes
- **Integración con control de versiones** para seguimiento de cambios de infraestructura

### Arquitectura de AWS Cloud
- **Implementación del Well-Architected Framework** a través de pilares de confiabilidad, seguridad y optimización de costos
- **Diseño de aplicaciones multi-tier** con integración apropiada de servicios
- **Planificación de arquitectura de red** con consideraciones de seguridad y rendimiento

### Prácticas de DevOps
- **Estrategia de gestión de ambientes** soportando múltiples etapas de despliegue
- **Gestión de configuración** a través de definiciones de infraestructura parametrizadas
- **Documentación y transferencia de conocimiento** a través de README comprensivo y comentarios en código

## 🚀 Mejoras Futuras

### Integración CI/CD
- Workflow de GitHub Actions para validación y despliegue automatizado de Terraform
- Pruebas automatizadas de cambios de infraestructura usando Terratest o frameworks similares
- Integración con AWS CodePipeline para despliegue continuo

### Monitoreo y Observabilidad
- Integración de dashboard de CloudWatch para monitoreo de infraestructura y aplicación
- Reglas de AWS Config para monitoreo de cumplimiento y detección de drift de configuración
- Integración de AWS X-Ray para trazado de aplicaciones distribuidas

### Seguridad Avanzada
- Integración de AWS WAF para protección a nivel de aplicación
- Análisis de VPC Flow Logs para detección de incidentes de seguridad
- Integración de AWS GuardDuty para detección de amenazas y monitoreo de seguridad

### Disaster Recovery
- Implementación de estrategia de backup cross-region
- Automatización de replicación de infraestructura para escenarios de disaster recovery
- Configuración y procedimientos de testing de point-in-time recovery de base de datos

---

## 📄 Technical Summary

**Project Overview**: Production-ready AWS infrastructure implementing a secure three-tier architecture using Terraform with multi-environment support (development, staging, production).

**Key Technologies**: Terraform, AWS VPC, EC2 Auto Scaling Groups, Application Load Balancer, RDS MySQL with Multi-AZ, AWS Secrets Manager, Apache HTTP Server.

**Architecture Pattern**: Three-tier architecture following AWS Well-Architected Framework principles with proper network isolation, security group layering, and automated scaling capabilities.

**Infrastructure Components**:
- **Networking**: Custom VPC with public/private subnets across multiple AZs, NAT Gateways, Internet Gateway
- **Security**: Defense-in-depth security groups, AWS Secrets Manager integration, principle of least privilege
- **Compute**: Auto Scaling Groups with Launch Templates, Application Load Balancer with health checks
- **Database**: RDS MySQL Multi-AZ deployment with automated backups and subnet groups

**DevOps Practices**: Infrastructure as Code with modular design, environment isolation, automated resource tagging, input validation, and comprehensive documentation.

**Scalability Features**: Dynamic auto scaling policies, multi-AZ deployment, load balancer health checks, configurable scaling boundaries for cost control.

---

## 📞 Información de Contacto

**Autor**: Jonathan Miskinich  
**Email**: [Send Email](miskinich.jobs.jonathan@gmail.com)  
**LinkedIn**: [Perfil  de LinkedIn](www.linkedin.com/in/jonathan-miskinich-cloudsecurity)  
**GitHub**: [Perfil de GitHub](github.com/MiskinichJonathanJ)

---

*Este proyecto demuestra patrones de diseño de infraestructura de nivel productivo y mejores prácticas de AWS adecuadas para ambientes empresariales. La arquitectura modular y escalable proporciona una base sólida para aplicaciones cloud modernas mientras mantiene eficiencia de costos y excelencia operacional.*
