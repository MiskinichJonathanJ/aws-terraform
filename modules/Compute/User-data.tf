data "aws_ami" "ubuntu" {
  most_recent = true

  #Filtros para la busqueda  de la AMI
  filter {
    #Como es el nombre  del atributo por el que  vamos a filtrar
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }

  #ID empresa canonical que es la oficial ne desarrollo Ubuntu
  owners = ["099720109477"]
}
