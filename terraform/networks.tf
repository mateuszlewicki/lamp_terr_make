resource "docker_network" "app_network_1" {
  name = "app_network_1"
  internal = true
  ipam_config{
      subnet="10.0.0.0/28"
  }
}

resource "docker_network" "app_network_2" {
  name = "app_network_2"
  internal = true
  ipam_config{
      subnet="10.0.0.16/28"
  }
}
resource "docker_network" "public_network" {
  name = "public_network"
  ipam_config{
      subnet="10.0.0.32/28"
  }
}