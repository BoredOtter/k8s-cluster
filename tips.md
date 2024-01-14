### force removing namespace stuck in terminating state
```bash
NAMESPACE=<YOUR_NAMESPACE>
kubectl get namespace $NAMESPACE -o json > $NAMESPACE.json
kubectl replace --raw "/api/v1/namespaces/$NAMESPACE/finalize" -f ./$NAMESPACE.json
kubectl get namespace
```
