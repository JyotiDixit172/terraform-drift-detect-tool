terraform {
  required_providers {
    kind = {
      source  = "tehcyx/kind"
      version = "0.3.0"
    }
  }
}

provider "kind" {}

resource "kind_cluster" "local" {
  name = "drift-demo"
}

/*
This tells Terraform:
Use KIND provider
Create one Kubernetes cluster
Track it in state
*/