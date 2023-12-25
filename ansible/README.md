Setting up cluster with its controllers:
`ansible-playbook setup-cluster.yaml  -i inventory.yaml`
TODO: 
- creating users 
- generateing kubeconfig for users

To setup apps:
`ansible-playbook setup-apps.yaml  -i inventory.yaml`
TODO:
- make easier to specify files to render
