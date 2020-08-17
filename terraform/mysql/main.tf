resource "docker_container" "db" {
  image = var.image
  name  = var.name
  networks_advanced{
      name=var.network.name
  }
  ports{
      internal = 3306
      external = 3306
  }
}
