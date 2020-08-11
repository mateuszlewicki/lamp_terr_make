---
title: Terraform part 
output: 
  html_document: 
    highlight: tango
    theme: paper
---
# Puprouse of using Terraform

## Brief of terrafom in current project
::: Warning ::::::
> This is a warning.

# List of files
- variables.tf
- images.tf
- terraform.tfvars
- terraform.tfstate
- outputs.tf
- networks.tf
- main.tf

::::::::::::::::::
# File description

## main.tf
```hcl
# terraform {
#   backend "local" {
#     path = "terraform.tfstate"
#   }
# }


provider "docker" {
#   host = "tcp://127.0.0.1:2376/"
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
    ip=docker_container.apache_1.ip_address
  }
  host{
    host="app2"
    ip=docker_container.apache_2.ip_address
  }
}

resource "docker_container" "apache_1" {
  image = docker_image.web.latest
  name  = "apache_1"
  networks_advanced{
      name=docker_network.app_network_1.name
  }
  ports{
      internal= var.http_port
      external= var.http_port
  }
  ports{
      internal = var.https_port
      external = var.https_port
  }
  host{
    host="db"
    ip=docker_container.db_1.ip_address
  }
}

resource "docker_container" "apache_2" {
  image = docker_image.web.latest
  name  = "apache_2"
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
  host{
    host="db"
    ip=docker_container.db_2.ip_address
  }
}

resource "docker_container" "db_1" {
  image = docker_image.db.latest
  name  = "db_1"
  networks_advanced{
      name=docker_network.app_network_1.name
  }
  ports{
      internal = var.db_port
      external = var.db_port
  }
}

resource "docker_container" "db_2" {
  image = docker_image.db.latest
  name  = "db_2"
  networks_advanced{
      name=docker_network.app_network_2.name
  }
  ports{
      internal = var.db_port
      external = var.db_port
  }
}

```
## images.tf

## networks.tf

## variables.tf

## outputs.tf

## terraform.tfvars