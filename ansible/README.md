
## Setting up basic cluster controllers and serivces:
`ansible-playbook setup-cluster.yaml -i inventory.yaml -u root --ask-vault-pass`

**This playbook sets up:**
- Python libraries for using K8s with Ansible
- Cert-manager cluster issuer
- Harbor
- Monitoring services (Grafana, Loki, Prometheus)
- ArgoCD


## ArgoCD Configuration:
`ansible-playbook setup-cluster.yaml -i inventory.yaml -u root --ask-vault-pass`

Sets up webhook, repositories, AppProjects, and Applications for ArgoCD based on the values specified in the main inventory.

## Deploying Synapse - Matrix homeserver:

`ansible-playbook setup-matrix.yaml -i inventory.yaml --ask-vault-pass`

 ## Deploying GHA Runners:
`ansible-playbook setup-gha-runners.yaml -i inventory.yaml --ask-vault-pass`
