resource "docker_container" "apache" {
  image = var.image
  name  = var.name
  networks_advanced{
      name=var.network.name
  }
  ports{
      internal= 80
      external= 80
  }
  ports{
      internal = 443
      external = 443
  }
  host{
    host="db"
    ip=var.db_ip
  }
}
