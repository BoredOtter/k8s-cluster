# Project Directory Structure

- `README.md`: This is the main README file for the project.
- `kubespray`: This directory contains the Kubespray project, which is a set of Ansible playbooks for Kubernetes deployment.
  - `CHANGELOG.md`: File containing the change log of the Kubespray project.
  - `CONTRIBUTING.md`: Guidelines for contributing to the Kubespray project.
  - `ansible.cfg`: Configuration file for Ansible.
  - `cluster.yml`: Main playbook for deploying a Kubernetes cluster.
  - `inventory`: Directory containing inventory files.
  - `roles`: Directory containing Ansible roles.
  - `scripts`: Directory containing scripts.
  - Other files and directories are part of the Kubespray project structure.
- `kubespray-venv`: This directory contains a Python virtual environment for running Kubespray.
- `terraform`: This directory contains Terraform configuration files for provisioning infrastructure.
  - `README.md`: README file for the Terraform configuration.
  - `gcp_creds.json`: Google Cloud Platform credentials file.
  - `id_rsa.pub`: Public SSH key for accessing provisioned resources.
  - `main.tf`: Main Terraform configuration file.
  - `setup.sh`: Script for setting up the environment.
  - `terraform.tfstate`: Terraform state file.
  - `terraform.tfstate.backup`: Backup of the Terraform state file.