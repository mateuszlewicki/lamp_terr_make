---
title: "GNU Make part"
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




# Puprouse of using GNU Make

GNU Make is a tool which controls the generation of executables and other non-source files of a program from the program's source files.

Make gets its knowledge of how to build your program from a file called the makefile, which lists each of the non-source files and how to compute it from other files. When you write a program, you should write a makefile for it, so that it is possible to use Make to build and install the program.

We can also say that GNU Make is a some kind of pipeline and can be use with conjunction with other pipeline as in Azure, Jenkins,  AWS, Gitlab with specifing a target for every stage.

You can find more about GNU Make Here:

- <https://www.gnu.org/software/make/>
- <https://www.gnu.org/software/make/manual/make.html>
- <https://makefiletutorial.com/>
- <https://www.cl.cam.ac.uk/teaching/0910/UnixTools/make.pdf>

## Brief overwiew of GNU Make in current project

Makefiles are described with `targets`, `dependencies` and `actions`.

In current project there are 4 Makefiles 1 - main and other 3 for building docker images

## Makefile
```makefile
deploy: build_images
	cd terraform; terraform apply -auto-approve

plan: 
	cd terraform; terraform plan

build_images: build_apache build_mysql build_lb

build_apache:
	docker build -t web ./images/web/
	docker tag web:latest localhost:5000/lamp_terr/web
	docker push localhost:5000/lamp_terr/web

build_mysql:
	docker build -t database ./images/database/
	docker tag database:latest localhost:5000/lamp_terr/database
	docker push localhost:5000/lamp_terr/database

build_lb:
	docker build -t loadbalancer ./images/loadbalancer/
	docker tag loadbalancer:latest localhost:5000/lamp_terr/loadbalancer
	docker push localhost:5000/lamp_terr/loadbalancer

.PHONY: clean

clean:
	cd terraform; terraform destroy -auto-approve
```
::: INFO
>This is [GNU Make Makefile](https://www.gnu.org/software/make/) with usage of [docker](https://docs.docker.com/engine/) and [terraform](https://www.terraform.io/docs/index.html) cli tools.
:::

## loadbalancer/Makefile
```makefile
publish:

dev: no_daemon add_dev_stats

install_proxy: 
	apk add haproxy

no_daemon: install_proxy
	sed -i '/daemon/ s/^/#/' /etc/haproxy/haproxy.cfg

add_frontent: install_proxy
	echo -e "frontend front\n\tbind *:80\n\tmode http\n\tdefault_backend back" >> /etc/haproxy/haproxy.cfg

add_dev_backend: add_frontent
	echo -e "\nbackend back\n\tmode http\n\tbalance roundrobin\n\tserver app1 app1:80 check\n\tserver app2 app2:80 check" >> /etc/haproxy/haproxy.cfg
add_dev_stats: add_dev_backend
	echo -e "\nfrontend stats\n\t bind *:1936\n\tmode http\n\tstats enable\n\t stats uri /" >> /etc/haproxy/haproxy.cfg
```
::: INFO
>This is [GNU Make Makefile](https://www.gnu.org/software/make/) with usage of [sh](https://www.unix.com/man-page/linux/1/sh/) inside [alpine linux](https://wiki.alpinelinux.org/wiki/Main_Page).
:::

## web/Makefile
```makefile
publish: dummy-file
	ls -l /usr/sbin/httpd

apache:
	apk add apache2

php-base: apache
	apk add php7 php7-fpm php7-apache2
php-add: php-base
	apk add php7-mysqli php7-pdo_mysql php7-mbstring php7-curl php7-dom

enable_php: php-add
	sed -i '/DirectoryIndex/ s/index.html/index.php index.html/' /etc/apache2/httpd.conf


dummy-file: enable_php 
	mv ./index.php /var/www/localhost/htdocs/index.php
```
::: INFO
>This is [GNU Make Makefile](https://www.gnu.org/software/make/) with usage of [sh](https://www.unix.com/man-page/linux/1/sh/) inside [alpine linux](https://wiki.alpinelinux.org/wiki/Main_Page).
:::


## database/Makefile
```makefile
publish: bootstrap db_start db_test db_stop

mysql-server:
	apk add mariadb

mysql-client: mysql-server
	apk add mysql-client mariadb-server-utils

mysql-base-init: mysql-client
	mysql_install_db --user=mysql --ldata=/var/lib/mysql > /dev/null

bootstrap: mysql-base-init
	/usr/bin/mysqld --user=mysql --bootstrap --verbose=0 --skip-networking=0 < ./bootstrap.sql

allow_connectivity: bootstrap
	sed -i '/skip-networking/ s/^/#/' /etc/my.cnf.d/mariadb-server.cnf

.PHONY: db_start db_stop db_test

db_start: allow_connectivity
	/usr/share/mariadb/mysql.server start

db_stop:
	/usr/share/mariadb/mysql.server stop

db_test: db_start
	mysql -u mlewicki --password=mlewicki -e 'SELECT * FROM test' mlewicki
```
::: INFO
>This is [GNU Make Makefile](https://www.gnu.org/software/make/) with usage of [sh](https://www.unix.com/man-page/linux/1/sh/) inside [alpine linux](https://wiki.alpinelinux.org/wiki/Main_Page).
:::
