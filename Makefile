test:
	flake8 --statistics
	pytest -v --cov
test-helm:
	helm install --dry-run --debug ./project-chart
install-python:
	pyenv install 3.7.4
	pyenv local 3.7.4
install-deps:
	pip3 install -r requirements.txt
	pip3 install flake8 pytest-cov freeze
install-minikube:
	minikube start -p project45
	minikube addons enable helm-tiller -p project45
destroy-minikube:
	minikube stop -p project45
	minikube delete -p project45
install:
	helm install ./project-chart
run-local:
	python -m flask run