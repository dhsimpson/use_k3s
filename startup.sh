#!/bin/bash
curl -sfL https://get.k3s.io | sh -
sudo chown ubuntu:ubuntu /etc/rancher/k3s/k3s.yaml
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
kubectl patch deployment -n argocd argocd-server --patch-file https://github.com/dhsimpson/kubeadm_on_ec2/blob/main/4.%20argocd%20%E1%84%8B%E1%85%B5%E1%84%8B%E1%85%AD%E1%86%BC%E1%84%92%E1%85%A2%20CD/no-tls.yml
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.1.3/deploy/static/provider/baremetal/deploy.yaml
kubectl delete validatingwebhookconfiguration ingress-nginx-admission
kubectl apply -n argocd -f https://github.com/dhsimpson/kubeadm_on_ec2/blob/main/4.%20argocd%20%E1%84%8B%E1%85%B5%E1%84%8B%E1%85%AD%E1%86%BC%E1%84%92%E1%85%A2%20CD/argocd-ing.yml

