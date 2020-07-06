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
destroy-minikube:
	minikube stop -p project42
	minikube delete -p project42
install:
	helm install ./chart
run-local:
	python -m flask run