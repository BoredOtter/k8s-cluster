kubectl -n kube-system create serviceaccount devops-cluster-admin

cat << EOF | kubectl apply -f -
apiVersion: v1
kind: Secret
metadata:
  name: devops-cluster-admin-secret
  namespace: kube-system
  annotations:
    kubernetes.io/service-account.name: devops-cluster-admin
type: kubernetes.io/service-account-token
EOF

cat << EOF | kubectl apply -f -
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: devops-cluster-admin
rules:
- apiGroups: [""]
  resources:
  - nodes
  - nodes/proxy
  - services
  - endpoints
  - pods
  verbs: ["get", "list", "watch"]
- apiGroups:
  - extensions
  resources:
  - ingresses
  verbs: ["get", "list", "watch"]
EOF

cat << EOF | kubectl apply -f -
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: devops-cluster-admin
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: devops-cluster-admin
subjects:
- kind: ServiceAccount
  name: devops-cluster-admin
  namespace: kube-system
EOF

export SA_SECRET_TOKEN=$(kubectl -n kube-system get secret/devops-cluster-admin-secret -o=go-template='{{.data.token}}' | base64 --decode)

export FRIENDLY_CLUSTER_NAME=k8s-bare-metal-0

export CLUSTER_NAME=$(kubectl config current-context)

export CURRENT_CLUSTER=$(kubectl config view --raw -o=go-template='{{range .contexts}}{{if eq .name "'''${CLUSTER_NAME}'''"}}{{ index .context "cluster" }}{{end}}{{end}}')

export CLUSTER_CA_CERT=$(kubectl config view --raw -o=go-template='{{range .clusters}}{{if eq .name "'''${CURRENT_CLUSTER}'''"}}"{{with index .cluster "certificate-authority-data" }}{{.}}{{end}}"{{ end }}{{ end }}')

export CLUSTER_ENDPOINT=$(kubectl config view --raw -o=go-template='{{range .clusters}}{{if eq .name "'''${CURRENT_CLUSTER}'''"}}{{ .cluster.server }}{{end}}{{ end }}')

cat << EOF > devops-cluster-admin-config
apiVersion: v1
kind: Config
current-context: ${FRIENDLY_CLUSTER_NAME}
contexts:
- name: ${FRIENDLY_CLUSTER_NAME}
  context:
    cluster: ${FRIENDLY_CLUSTER_NAME}
    user: devops-cluster-admin
clusters:
- name: ${FRIENDLY_CLUSTER_NAME}
  cluster:
    certificate-authority-data: ${CLUSTER_CA_CERT}
    server: ${CLUSTER_ENDPOINT}
users:
- name: devops-cluster-admin
  user:
    token: ${SA_SECRET_TOKEN}
EOF