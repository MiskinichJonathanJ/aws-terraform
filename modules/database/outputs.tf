output "endpoint" {
  value = aws_db_instance.MyDB.endpoint
  description = "Endpoint para la  conexion a la DB"
}

output "port" {
  value = aws_db_instance.MyDB.port
  description = "Puerto  para conexion  con DB"
}

output "db_name" {
  value = aws_db_instance.MyDB.db_name
  description = "Nombre de  la Base de datos"
}

output "secret_arn" {
  value = aws_db_instance.MyDB.arn
  description = "ARN de la  base de datos"
}
