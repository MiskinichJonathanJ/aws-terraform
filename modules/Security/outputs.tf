output "id_web_security_group" {
  value = aws_security_group.web_sg.id
  description = "ID del grupo de seguridad para capa web"
}

output "id_app_security_group" {
  value = aws_security_group.app_sg.id
  description = "ID del grupo de seguridad para capa App"
}

output "id_db_security_group" {
  value = aws_security_group.db_sg.id
  description = "ID del grupo de seguridad para capa base de datos"
}
