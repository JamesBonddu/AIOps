kubectl create secret docker-registry ali-hk-harbor-credentials \
  --docker-server=http://host:port \
  --docker-username=admin \
  --docker-password=passwd \
  --docker-email=admin@example.com


kubectl edit configmap argocd-cm -n argocd


kubectl rollout restart deployment argocd-server -n argocd
kubectl rollout restart deployment argocd-repo-server -n argocd
