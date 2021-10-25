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
	mysql -u user --password=pass -e 'SELECT * FROM test' exampleDB
