# terraform-learning-EPAM_V2.0

Terraform configurations for GCP 

## Repository Structure

terraform-learning-EPAM_V2.0/
├── modules/
│   ├── network/                # Defines VPC and Subnets
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   ├── compute/                # Defines Compute Engine
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   ├── firewall/               # Defines Firewall Rules
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   └── loadbalancer/          # Defines Load Balancer, Backend Services, and Cloud Armor
│         ├── main.tf
│         ├── variables.tf
│         └── outputs.tf
├── envs/
│   ├── dev/                    # Environment-specific configuration for Development
│   │  ├── backend.tfvars
│   │  └─── terraform.tfvars
│   ├── uat/                    # Environment-specific configuration for UAT
│   │  ├── backend.tfvars
│   │  └─── terraform.tfvars
│   └── prod/                  # Environment-specific configuration for Production
│        ├── backend.tfvars
│        └─── terraform.tfvars
├── bootstrap/                  # Initial setup for remote state backend
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └─── outputs.tf
├── main.tf                     # Root configuration that calls the reusable modules
├── providers.tf                # The Terraform providers configuration      
├── variables.tf                # Vvariables for the root module.
└─── versions.tf                # The versions of Terraform and the providers.
