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