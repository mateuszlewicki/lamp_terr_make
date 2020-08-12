---
title: "Terraform part"
author: "Mateusz Lewicki"
date:  "sierpień 12, 2020"
output:
  html_document: 
    theme: united
    highlight: pygments
    toc: yes
    css: blocks.css
    keep_md: yes
---








# Puprouse of using Terraform

Terraform by Hashicorp is infrastructure description langauage in HLC format (Hashicorp DSL) used in widely name CI/CD for construction of all needed infrastructure components for application by using principles of infrastructure as code.

## Brief of terrafom in current project
Project consist of 6/7 terraform files (6 as code and 7th for state):

- [main.tf](../terraform/main.tf)
- [images.tf](../terraform/images.tf)
- [networks.tf](../terraform/networks.tf)
- [outputs.tf](../terraform/outputs.tf)
- [variables.tf](../terraform/variables.tf)
- [terraform.tfvars](../terraform/terraform.tfvars)
- [terraform.tfstate](../terraform/terraform.tfstate)

In this project Terraform is used to build "2 tier" infrastructure with loadbalancing in docker.

<center>
<!--html_preserve--><div id="htmlwidget-227c7f79faec01a61dee" style="width:672px;height:480px;" class="DiagrammeR html-widget"></div>
<script type="application/json" data-for="htmlwidget-227c7f79faec01a61dee">{"x":{"diagram":"\ngraph LR;\n    A[Client]-->|public| B[HAproxy]\n    B-->|private| C[Apache+PHP7]\n    C-->E[MySQL]\n    B-->|private| D[Apache+PHP7]\n    D-->F[MySQL]\n    subgraph 10.0.0.32/26\n    B\n    end\n    subgraph 10.0.0.0/26\n    C\n    E\n    end\n    subgraph 10.0.0.16/26\n    D\n    F\n    end\n"},"evals":[],"jsHooks":[]}</script><!--/html_preserve-->
</center>

Terrraform code was split into parts (see above).  
Terraform by default is looking through directory for every Terraform related files.   
Terrafom does not need to have entrypoint file, but it is good practice to have main file.  
Without [backend](https://www.terraform.io/docs/configuration/backend.html) declaration Terraform is using by default `local` provider which means that state file will be created in the same directory

# File description

## main.tf (part of)
```typescript
provider "docker" {
}


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

[...]

```
::: INFO
>This file consist of [provider](https://www.terraform.io/docs/providers/index.html) 
and [resource](https://www.terraform.io/docs/configuration/resources.html) declaration blocks 
used by [Terraform Configuration Language](https://www.terraform.io/docs/configuration/index.html) 
and [Docker Provider](https://www.terraform.io/docs/providers/docker/index.html)
:::

::: CODE_DESCIPTION
### Overwiew
**main.tf** file is (as the name suggests) the main file of whole infrastructure builded in this project. 
At the top we have `provider` block it is saying that we want to use a docker provider in the latest version (as we don't specified the version)   
Here we have a snippet of on of the **`docker_container`** resource with identifier **`LB`**. This resource is part of Docker provider described above. 
It's built with several fields and block:  

####  **`image = docker_image.lb.latest` - (type: String)  **

>It is a name (or project/name) of the docker image to use. In this case we are referring to `docker_image` resource with `lb` identifier and the `latest`     version. `.latest` can be replaced by `:latest` tag

#### **`name = "LB"` - (type: String)**

>Literal name 

#### **`networks_advanced{name=docker_network.public_network.name }` - (type:block->String)**
 
> Block where we define to which network container should be attached (one block for one network).  
> Inside we have `name` field where we ae using name of network (in this case public) from resource `docker_network` defined in *networks.tf* file

#### **`  ports{ internal= var.http_port external= var.http_port }` - (type:block->Int,Int)**

> Block with definition which ports should be exposed (one block for one ports pair). Here we are using ports from variable `http_port`

#### **`host{ host="app1" ip=docker_container.apache_1.ip_address }`- (type:block->String,String)**  

> Block used for additional `/etc/hosts` entries. Here we are using `ip_address` from `apache_1` the `docker_container` resource 
:::


## images.tf
```typescript
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
```
::: INFO
>This file consist of [resource](https://www.terraform.io/docs/configuration/resources.html) declaration blocks 
used by [Docker Provider](https://www.terraform.io/docs/providers/docker/index.html) 
:::
::: CODE_DESCIPTION

### Overwiew
**images.tf** file contains definitions of container images, which we can then use in `docker_container` resource.   
File defines several `docker_image` blocks one for single image. This block in this case has two fields:  

#### **`name = "${var.registry}/${var.web_image_name}"` - (type: String)**
> This field defines which image to use. In this particural entry we use custom registry and image name defined in own variables.  
> In the first resource block in source file you can find literall name of image `alpine:latest`

#### **`keep_locally = true` - (type: Boolean)**
> This field is informing provider to not remove images when `destroy` command is provided.
:::

## networks.tf
```typescript
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
```
::: INFO
>This file consist of [resource](https://www.terraform.io/docs/configuration/resources.html) declaration blocks 
used by [Docker Provider](https://www.terraform.io/docs/providers/docker/index.html) 
:::
::: CODE_DESCIPTION

### Overwiew
**networks.tf** file contains definitions of docker networks, which we can then use in `docker_container` resource.   
File defines several `docker_network` blocks one for single network. This block in this case has several fields such as:  

#### **`name = "app_network_1"` - (type: String)**
> This field defines name of network

#### **`internal = true` - (type: Boolean)**
> This field is informing provider that this network is private, and will not be accessible from outside (default public)

#### **`ipam_config{subnet="10.0.0.32/28" }` - (type: Block -> Boolean)**
> This block is having `subnet` field which consist network_addr/mask
:::

## variables.tf
```typescript
variable "http_port" {
  type        = string
}

variable "https_port" {
  type        = string
}

variable "db_port" {
  type        = string
}

variable "registry" {
  type        = string
}

variable "db_image_name" {
  type        = string
}
variable "web_image_name" {
  type        = string
}
variable "lb_image_name" {
  type        = string
}
```
::: INFO
>This file consist of [variable](https://www.terraform.io/docs/configuration/variables.html) declaration blocks 
used by [Terraform Configuration Language](https://www.terraform.io/docs/configuration/index.html) 
:::
::: CODE_DESCIPTION

### Overwiew
**variables.tf** file contains definitions of variables.   
Definition consist of `variable` resource keyword and identifier:

#### **`type = String (type: predefined primitive)`**
>Field which determines type of variable 
:::

## outputs.tf
```typescript
output "apache_1_ip_addr" {
  value = docker_container.apache_1.ip_address
}

output "apache_2_ip_addr" {
  value = docker_container.apache_2.ip_address
}
output "LB_ip_addr" {
  value = docker_container.LB.ip_address
}
```
::: INFO
>This file consist of [output](https://www.terraform.io/docs/configuration/outputs.html) declaration blocks 
used by [Terraform Configuration Language](https://www.terraform.io/docs/configuration/index.html) 
:::
::: CODE_DESCIPTION

### Overwiew
**outputs.tf** file contains declaration of properties which will be produced at output of `apply` command.  

#### **`value = docker_container.apache_1.ip_address` - (type: any)**
> Field for assigning value for output
:::


## terraform.tfvars
```typescript
  http_port = "80"
  https_port = "443"
  db_port = "3306"
  registry = "localhost:5000"
  web_image_name = "lamp_terr/web"
  db_image_name = "lamp_terr/database"
  lb_image_name = "lamp_terr/loadbalancer"
```
::: INFO
>This file consist of [variable definitions](https://www.terraform.io/docs/configuration/variables.html#variable-definitions-tfvars-files)
:::
::: CODE_DESCIPTION

### Overwiew
**terraform.tfvars** file contains values for variables.   
*file `*.tfvars` is used by default if it is in the root folder of Terraform project*
:::
