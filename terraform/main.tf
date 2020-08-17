# terraform {
#   backend "local" {
#     path = "terraform.tfstate"
#   }
# }


provider "docker" {
#   host = "tcp://127.0.0.1:2376/"
#private laptop
# host = "ssh://mlewicki@192.168.1.76:22"
}
# variables

## moved > ./variables.tf

# Images

## moved > ./images.tf

#Networks

## moved > ./networks.tf


#machines

resource "docker_container" "LB" {
  image = docker_image.lb.latest
  name  = "LB"
  networks_advanced{
      name=docker_network.public_network.name
  }
  networks_advanced{
      name=docker_network.app_network_1.name
  }
  networks_advanced{
      name=docker_network.app_network_2.name
  }
  ports{
      internal= var.http_port
      external= var.http_port
  }
  ports{
      internal = var.https_port
      external = var.https_port
  }
   ports{
      internal = 1936
      external = 1936
  }
  host{
    host="app1"
    ip=module.apache_1.ip_address
  }
  host{
    host="app2"
    ip=module.apache_2.ip_address
  }
}

module "apache_1" {
  source = "./apache"
  name="apache_1"
  image=docker_image.web.latest
  network=docker_network.app_network_1
  db_ip=module.db_1.ip_address
}

module "apache_2" {
  source = "./apache"
  name="apache_2"
  image=docker_image.web.latest
  network=docker_network.app_network_2
  db_ip=module.db_2.ip_address
}

module "db_1" {
  source = "./mysql"
  image=docker_image.db.latest
  name= "db_1"
  network= docker_network.app_network_1
}
module "db_2" {
  source = "./mysql"
  image=docker_image.db.latest
  name= "db_2"
  network= docker_network.app_network_2
}
