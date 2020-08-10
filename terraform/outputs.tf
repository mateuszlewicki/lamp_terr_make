output "apache_1_ip_addr" {
  value = docker_container.apache_1.ip_address
}

output "apache_2_ip_addr" {
  value = docker_container.apache_2.ip_address
}
output "LB_ip_addr" {
  value = docker_container.LB.ip_address
}
