---
title: "Terraform module part"
author: "Mateusz Lewicki"
date:  "sierpień 17, 2020"
output:
  html_document: 
    theme: united
    highlight: pygments
    toc: yes
    css: blocks.css
    keep_md: yes
---
# Puprouse of using Terraform Modules
Modules can be used to split code into reusable chunks like functions in programming languages. 
In terrafrom philosophy every directory is a module. Module can also have own sub-modules and so on.





## terraform/apache/main.tf

```typescript
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
```
::: INFO
>This file consist of [resource](https://www.terraform.io/docs/configuration/resources.html) declaration blocks 
used by [Docker Provider](https://www.terraform.io/docs/providers/docker/index.html) 
:::

## terraform/mysql/main.tf

```typescript
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
```
::: INFO
>This file consist of [resource](https://www.terraform.io/docs/configuration/resources.html) declaration blocks 
used by [Docker Provider](https://www.terraform.io/docs/providers/docker/index.html) 
:::

## terraform/main.tf - usage

```typescript
[...]

module "apache_1" {
  source = "./apache"
  name="apache_1"
  image=docker_image.web.latest
  network=docker_network.app_network_1
  db_ip=module.db_1.ip_address
}

[...]


module "db_1" {
  source = "./mysql"
  image=docker_image.db.latest
  name= "db_1"
  network= docker_network.app_network_1
}

```
::: INFO
>This file consist of [provider](https://www.terraform.io/docs/providers/index.html),
[module](https://www.terraform.io/docs/modules/index.html)
and [resource](https://www.terraform.io/docs/configuration/resources.html) declaration blocks 
used by [Terraform Configuration Language](https://www.terraform.io/docs/configuration/index.html) 
and [Docker Provider](https://www.terraform.io/docs/providers/docker/index.html)
:::
::: CODE_DESCIPTION

### Overwiew
For using a module you need to use `module` keyword with id. Then you need specify `source` path do module and fill with variables.   
You can use module multiple times for example we used two times `apache` and `mysql` modules and they will create two different machines
:::