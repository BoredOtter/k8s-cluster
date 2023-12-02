# Clean up old Kubernetes cluster with Ansible Playbook (run in Kubespray directory)
ansible-playbook -i inventory/mycluster/hosts.yaml --become --become-user=root reset.yml

# Deploy Kubespray with Ansible Playbook (run in Kubespray directory)
ansible-playbook -i inventory/mycluster/hosts.yaml --become --become-user=root cluster.yml

# Project Directory Structure
- `kubespray`: This directory contains the modefied repo of Kubespray project.
- `terraform`: This directory contains Terraform configuration files for provisioning infrastructure.
- `apps`: This directory contains the Kubernetes manifests for deploying applications.
- `docs`: This directory contains the documentation of the project.
- `controllers`: This directory contains the deployments for the controllers. (TODO: rewrite this to Ansible playbook)