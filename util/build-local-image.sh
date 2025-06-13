eval $(minikube -p epam-project docker-env)
docker build -t application:dev ./services/application/
