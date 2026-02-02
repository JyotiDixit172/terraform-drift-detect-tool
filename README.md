# Terraform Drift Detection Tool

A toolkit for managing Terraform infrastructure across multiple platforms with a focus on drift detection and secure deployment practices.

## 📋 Overview

This repository demonstrates Terraform infrastructure management across Azure, Kubernetes (KIND), and Minikube, with emphasis on drift detection, state management, and security best practices.

---

## 🚀 Quick Start

```bash
# Navigate to desired platform
cd terraform-drift-detect-tool/<platform-folder>

# Initialize and apply
terraform init
terraform plan
terraform apply
```

### Prerequisites
- Terraform >= 1.0
- Azure CLI / Docker / Minikube (depending on platform)

---

## 📁 Structure

```
terraform-drift-tool/
├── docs/                          # Detailed documentation
├── terraform-drift-detect-tool/   # Terraform configurations
│   ├── tf-cloud-vm/              # Azure VM deployments
│   ├── tf-kind/                  # Kubernetes KIND clusters
│   ├── tf-minikube/              # Minikube environments
│   └── tf-pipeline/              # CI/CD infrastructure
```

---

## 📚 Documentation

- **[Detailed Documentation](docs/README.md)** - Comprehensive guides and references
- **[Security Guide](docs/SECURITY_CLEANUP_GUIDE.md)** - Secret management and cleanup

---

## 🔑 Key Features

- Multi-platform infrastructure support (Azure, KIND, Minikube)
- Terraform drift detection demonstrations
- Secure state file management
- Comprehensive `.gitignore` protection

---

## 🛡️ Security

All sensitive files are protected by `.gitignore`:
- `*.tfstate` / `*.tfvars` - Contains credentials
- `*-config` - Kubernetes certificates
- `*.pem` / `*.key` - SSH/RSA keys

See [Security Guide](docs/SECURITY_CLEANUP_GUIDE.md) for handling exposed secrets.

---

## ⚠️ Important

This is a demonstration repository for learning Terraform drift detection. Always review changes before applying to production environments.

---

## 📖 Resources

- [Terraform Docs](https://www.terraform.io/docs)
- [Detailed Documentation](docs/README.md)