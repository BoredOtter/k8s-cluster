## Playbook for setting up basic cluster controllers and serivces:

`ansible-playbook setup-cluster.yaml -i inventory.yaml -u root -ask-vault-pass`

####  Contains 4 roles:

1.  k8s_dependencies:
    -   installs Python packages that are necessary for Ansible to interact with a Kubernetes cluster.
2.  Cluster Issuer
    -   Configures and establishes the cluster issuer, a critical component for managing certificates and ensuring secure communication within the cluster.
3.  Harbor
    -   Sets up Harbor - container registry for docker images.
4.  Kyverno
    -   Integrates Kyverno, a policy management tool for Kubernetes, ensuring the enforcement of policies to enhance security and compliance within the cluster.

TODO:
- creating users
- generateing kubeconfig for users

  

## Deploying Synapse - Matrix homeserver:

`ansible-playbook setup-matrix.yaml -i inventory.yaml --ask-vault-pass`

TODO:
- find what to do lol