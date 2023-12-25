## Kubespray:
### Steup env for Kubespray:

```bash
VENVDIR=kubespray-venv
KUBESPRAYDIR=kubespray
python3 -m venv $VENVDIR
source $VENVDIR/bin/activate
cd $KUBESPRAYDIR
pip install -U -r requirements.txt
```

### Ansible Kubespray commands:
### Run in `Kubespray` directory:

#### Clean up old Kubernetes cluster with Ansible Playbook

`ansible-playbook -i inventory/mycluster/hosts.yaml --become --become-user=root reset.yml`

 
#### Deploy Kubespray with Ansible Playbook
`ansible-playbook -i inventory/mycluster/hosts.yaml --become --become-user=root cluster.yml`

  

# Project Directory Structure

-  `kubespray`: This directory contains the modefied repo of Kubespray project.

-  `tofu`: This directory contains OpenTofu configuration files for provisioning infrastructure.

-  `apps`: This directory contains the Kubernetes manifests for deploying applications.

-  `docs`: This directory contains the documentation of the project.

-  `controllers`: This directory contains the deployments for the controllers. (TODO: rewrite this to Ansible playbook)
