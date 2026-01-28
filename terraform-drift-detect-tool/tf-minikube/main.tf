resource "null_resource" "minikube_cluster" {
  provisioner "local-exec" {
    command = "minikube start --driver=docker"
  }
  provisioner "local-exec" {
    when    = destroy
    command = "minikube delete"
  }
}

/*
tf apply -> minikube starts
tf destroy -> minikube delete

ls -a = show everything, even hidden stuff
terraform fmt
terraform validate

terraform plan -out=tfplan
terraform apply tfplan
terraform show tfplan
*/