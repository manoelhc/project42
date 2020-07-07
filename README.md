# project42 ![Docker Image CI](https://github.com/manoelhc/project42/workflows/Docker%20Image%20CI/badge.svg)

Welcome to Project 42 - A Simple Flask application for Kubernetes.

## Requirements

### For development
 * `make`: use `brew`, `apt`, `yum`, `choco` or your prefered package manager.
 * `pyenv`: https://github.com/pyenv/pyenv
 * `minikube`: https://kubernetes.io/docs/setup/learning-environment/minikube/
 * `helm`: https://helm.sh/

### For deployment

A Kubenetes cluster. How to create it? Glad you asked :)

There are 2 simple ways to create a K8s on AWS:
 * `ekscli`: https://docs.aws.amazon.com/eks/latest/userguide/eksctl.html#installing-eksctl
 * https://github.com/manoelhc/k8s-simple-deployment (my other porject)

Local test:
 * `docker build -t project42 .`
 * `docker run -p 5000:5000 project42`

Local environment:
 * Run `make install-minikube` to initiate a local cluster;
 * Run `make install` to install the app;

Install on AWS:
 * Setup a domain for it
 * Create a secret named `project42` entry with the certificates
 * Run `helm upgrade --install project45 --set '.Values.mysql.connString=mysql://<username>:<password>@<host>/<database>' --set '.Values.ingress.hosts[0].host=<your_hostname>'  ./charts` 


## Pipeline

Once a PR is created on GitHub, it triggers Github Actions jobs to test the code, build Docker images and push the images to Docker Hub. After that, you can test locally by running `make install` or remote (AWS) by running the helm command described in the previous section. Make sure you have a MySQL installation and add the required information to the command line.

## Docker Repo
https://hub.docker.com/r/manoelhc/project42/tags

