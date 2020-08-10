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