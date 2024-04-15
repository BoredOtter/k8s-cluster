
## K8S Cluster Setup

This repository hosts a collection of tools, including Kubespray Inventory and various Ansible-based playbooks and roles, designed to setup of Kubernetes clusters on bare-metal or VPS servers. 

Setting up the entire cluster with additional services takes up to 30 minutes.

The basic setup of the cluster relies on Kubespray and its tweaked inventory. Kubespray handles the installation of essential components like the [Rancher Local-Path provisioner](https://github.com/rancher/local-path-provisioner), [Nginx ingress controller](https://github.com/kubernetes/ingress-nginx) and [Cert-manager](https://github.com/cert-manager/cert-manager). This configuration ensures that these components are smoothly integrated into the cluster setup, making it easier to manage and utilize Kubernetes.

## Additional Services:
-   **Monitoring**:
    -   [Grafana](https://github.com/grafana/grafana)
    -   [Loki](https://github.com/grafana/loki)
    -   [Prometheus](https://github.com/prometheus/prometheus)
-   **Continuous Deployment**:
    -   [ArgoCD](https://github.com/argoproj/argo-cd)
-   **Continuous Integration**:
    -   [ARC - Kubernetes controller for GitHub Actions self-hosted runners](https://github.com/actions/actions-runner-controller)
-   **Image Registry**:
    -   [Harbor](https://github.com/goharbor/harbor)
-   **Misc**:
    -   [Synapse - Matrix Server](https://github.com/element-hq/synapse)
    -   [Visual Studio Code Server](https://github.com/coder/code-server)
    -   [Jupyter Notebook](https://github.com/jupyter/jupyter)


## Python environment setup for Ansible:
```bash
VENVDIR=kubespray-venv
KUBESPRAYDIR=kubespray
python3  -m  venv  $VENVDIR
source  $VENVDIR/bin/activate
cd  $KUBESPRAYDIR
pip  install  -U  -r  requirements.txt
```

## Kubespray playbooks:

**Run in `Kubespray` directory:**

**Clean up old Kubernetes cluster with Ansible Playbook:**

`ansible-playbook -i inventory/mycluster/hosts.yaml --become --become-user=root reset.yml`

**Deploy cluster with Ansible Playbook**

`ansible-playbook -i inventory/mycluster/hosts.yaml --become --become-user=root cluster.yml`

# Project Directory Structure

-  `kubespray`: This directory contains Kubespray files with modified inventory file.
-  `ansible`: This directory constains custom Ansible roles and playbooks written to setup cluster infrastucture like Grafana etc.
-  `tofu`: This directory contains OpenTofu configuration files for provisioning infrastructure (GCP).
-  `docs`: This directory contains the documentation of the project.
