# Cloud Launchpad Terraform

This repository contains Terraform code to provision a modular AWS infrastructure, including VPC networking, compute resources, and logging, with support for multiple environments.

## Project Directory Structure

```text
cloud-launchpad-tf/
├── backend.tf             # Backend configuration for Terraform state
├── main.tf                # Root configuration, wires modules together
├── variables.tf           # Input variables for the project
├── provider.tf            # Provider configuration (AWS)
├── pre-prod.tfvars        # Pre-production environment variables
├── prod.tfvars            # Production environment variables
├── images/
│   └── AWS_Architecture.png # Architecture diagram
├── modules/
│   ├── network/           # VPC and subnet resources
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   └── variables.tf
│   ├── computer/          # EC2 instances and security groups
│   │   ├── ami.tf
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   └── variables.tf
│   └── logging/           # CloudWatch and S3 logging
│       ├── main.tf
│       ├── outputs.tf
│       └── variables.tf
└── .github/
    └── workflows/
        └── terraform.yml  # CI/CD pipeline configuration
```

### Component Descriptions

- **Root Configuration**:
  - `main.tf`: Orchestrates the modules and defines the overall architecture
  - `variables.tf`: Declares input variables used across the project
  - `provider.tf`: Configures the AWS provider
  - `backend.tf`: Configures the backend for storing Terraform state
  - `pre-prod.tfvars` & `prod.tfvars`: Environment-specific variable values

- **Modules**:
  - **Network**: Creates VPC, subnets, internet gateway, and route tables
  - **Computer**: Provisions EC2 instances and configures security groups
  - **Logging**: Sets up CloudWatch log groups and S3 bucket for VPC flow logs (enabled only in production)

## Running the Project

`this instruction is to use manual steps to run the project it is also automated in the CI/CD pipeline just push your code `
This project uses Terraform workspaces to manage different environments (pre-prod and prod). Follow these steps to deploy the infrastructure:

### 1. Initialize Terraform

Initialize your Terraform working directory:

```bash
terraform init
```

###  write your tfvars files
Create `pre-prod.tfvars` and `prod.tfvars` files with the necessary variables for each environment. Example content:

```hcl

# pre-prod.tfvars
project_name = "poc-pre-prod"

# VPC Configuration
vpc_cidr_block = "10.0.0.0/16"

# Subnets Configuration
subnets_list = [
  {
    name              = "poc-pre-prod-subnet-public-1"
    cidr              = "10.0.1.0/24"
    type              = "public"
    availability_zone = "us-east-1a"
  },
  {
    name              = "poc-pre-prod-subnet-public-2"
    cidr              = "10.0.2.0/24"
    type              = "public"
    availability_zone = "us-east-1b"
  }
]

```

> **Note:** The number of `subnets` is the number of ec2 instances that will be launched in the `computer` module and this version of network module does not support `NAT` so if create private subnet you will not be able to log in inside it.

### Select Environment

```sh
terraform workspace new pre-prod
# and
terraform workspace new prod
```

### Plan

Note: select your environment by using `workspace` and by specifying the `-var-file` option.
```sh
terraform workspace select pre-prod
terraform plan -var-file=pre-prod.tfvars
# or
terraform workspace select prod
terraform plan -var-file=prod.tfvars
```

### Apply

```sh
terraform apply -var-file=pre-prod.tfvars
# or
terraform apply -var-file=prod.tfvars
```

## Modules

### Network

- Provisions a VPC and subnets as defined in `subnets_list`.

### Computer

- Launches EC2 instances in each subnet.
- Attaches a security group allowing SSH access.

### Logging

- Creates CloudWatch log groups and S3 bucket for VPC flow logs.
- Only enabled in the `prod` workspace.

## Notes

- Logging resources are only created in the `prod` environment.
- All resources are tagged with the project name for easy identification.
- Sensitive files (`*.tfvars`) are excluded from version control.

## Architecture

![Architecture Diagram](images/AWS_Architecture.png)

The architecture diagram illustrates the infrastructure deployed by this Terraform project, showing the relationship between VPC, subnets, EC2 instances, and logging resources.
