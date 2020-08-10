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
