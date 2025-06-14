cd terraform
terraform init
terraform plan
terraform apply -auto-approve
aws eks update-kubeconfig --region us-east-1 --name my-app
cd ../
kubectl apply -k ./k8s/overlays/prod