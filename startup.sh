#!/bin/bash
curl -sfL https://get.k3s.io | sh -
sudo chown ubuntu:ubuntu /etc/rancher/k3s/k3s.yaml
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
cat <<EOF > no-tls.yml 
spec:
  template:
    spec:
      containers:
      - name: argocd-server
        command: 
          - argocd-server
          - --insecure
EOF
kubectl patch deployment -n argocd argocd-server --patch-file no-tls.yml
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.1.3/deploy/static/provider/baremetal/deploy.yaml
kubectl delete validatingwebhookconfiguration ingress-nginx-admission
cat <<EOF > argocd-ing.yml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: argocd-server-ingress
  annotations:
    kubernetes.io/ingress.class: nginx
    nginx.ingress.kubernetes.io/force-ssl-redirect: "true"
    nginx.ingress.kubernetes.io/ssl-passthrough: "true"
spec:
  rules:
    - http:
        paths:
          - pathType: Prefix
            path: "/"
            backend:
              service:
                name: argocd-server
                port:
                  number: 443
EOF
kubectl apply -n argocd -f argocd-ing.yml

