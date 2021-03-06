---
title: "Docker part"
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





# Puprouse of using Docker

Docker is a "container " (linux namespace) daemon which is capable of making small virtual environments named containers to isolate application without using extensive virtualization methods

## Brief of docker in current project
Project consist of 3 Dockerfiles:

- [loadbalancer/Dockerfile](../images/loadbalancer/Dockerfile)
- [web/Dockerfile](../images/web/Dockerfile)
- [database/Dockerfile](../images/database/Dockerfile)

In this project docker is used for isolating application and create virtualized network for them to communicate 

## loadbalancer/Dockerfile

```dockerfile
FROM alpine:3.12
RUN apk add make
ADD ./Makefile ./Makefile

RUN make dev

CMD haproxy -f /etc/haproxy/haproxy.cfg
```
::: INFO
>This file is using [GNU Make](https://www.gnu.org/software/make/) for building the image
:::

## web/Dockerfile

```dockerfile
FROM alpine:3.12
RUN apk add make
ADD ./Makefile ./Makefile
ADD ./index.php ./index.php
RUN make publish
CMD /usr/sbin/httpd -k start -D FOREGROUND
```
::: INFO
>This file is using [GNU Make](https://www.gnu.org/software/make/) for building the image
:::

## database/Dockerfile

```dockerfile
FROM alpine:3.12
RUN apk add make
ADD ./Makefile ./Makefile
ADD ./bootstrap.sql ./bootstrap.sql
RUN make publish

CMD ["mysqld_safe"]
```
::: INFO
>This file is using [GNU Make](https://www.gnu.org/software/make/) for building the image
:::

::: CODE_DESCIPTION

### Overwiew
**Dockerfile**s file contains description of docker image.   
In current project all images are built with make and have (mostly) the sae set of commands such as:

#### **`FROM alpine:3.12`**
>Command for defining the base image on top which we will be building our own

#### **`RUN apk add make`**
>Command for executing commands on docker container

#### **`ADD ./Makefile ./Makefile`**
>Command for sending file form local (left) to remote (right) filesytem 

#### **`CMD haproxy -f /etc/haproxy/haproxy.cfg`**
>Command for definign startup app for container.   
> **IMPORTANT!**  
>Containers **need** to have defined starting process which will be attached to main TTY otherwise container will die
:::
