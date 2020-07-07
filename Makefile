test:
	flake8 --statistics --exclude=*/lib/*
	pytest -v --cov --ignore-glob='*/lib/*'
test-helm:
	helm install --dry-run --debug ./chart
install-python:
	pyenv install 3.7.4
	pyenv local 3.7.4
install-deps:
	pip install -r requirements.txt
	pip install flake8 pytest-cov freeze
install-minikube:
	minikube start -p project42
	minikube addons enable helm-tiller -p project42 
	minikube addons enable ingress -p project42 
	minikube addons enable ingress-dns -p project42 
	minikube addons list -p project42
	openssl req -x509 -sha256 -newkey rsa:4096 -keyout ca.key -out ca.crt -days 356 -nodes -subj '/CN=Project42 Authority'
	openssl req -new -newkey rsa:4096 -keyout server.key -out server.csr -nodes -subj '/CN=project42.local'
	openssl x509 -req -sha256 -days 365 -in server.csr -CA ca.crt -CAkey ca.key -set_serial 01 -out server.crt
	openssl req -new -newkey rsa:4096 -keyout client.key -out client.csr -nodes -subj '/CN=Project42'
	openssl x509 -req -sha256 -days 365 -in client.csr -CA ca.crt -CAkey ca.key -set_serial 02 -out client.crt
	kubectl create secret generic project42 --from-file=tls.crt=server.crt --from-file=tls.key=server.key --from-file=ca.crt=ca.crt
	rm ca.key ca.crt server.csr server.key client.csr client.crt client.key
	kubectl get secret project42
destroy-minikube:
	minikube stop -p project42
	minikube delete -p project42
install:
	kubectl run mysql --image=mysql:latest --env="MYSQL_USER=mysql" --env="MYSQL_PASSWORD=mysql" --env="MYSQL_DATABASE=project42" --env="MYSQL_ROOT_PASSWORD=mysql"
	sleep 30
	helm install ./charts
run-local:
	python -m flask run