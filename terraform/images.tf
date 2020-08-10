resource "docker_image" "alpine" {
  name = "alpine:latest"
  keep_locally = true
}

resource "docker_image" "web" {
  name = "${var.registry}/${var.web_image_name}"
  keep_locally = true
}

resource "docker_image" "db" {
  name = "${var.registry}/${var.db_image_name}"
  keep_locally = true
}

resource "docker_image" "lb" {
  name = "${var.registry}/${var.lb_image_name}"
  keep_locally = true
}