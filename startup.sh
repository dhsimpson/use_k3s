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

