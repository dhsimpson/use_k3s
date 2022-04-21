### k3s 설치 & 실행 & 권한부여 & 설정복사
1. curl -sfL https://get.k3s.io | sh -
2. sudo chown ubuntu:ubuntu /etc/rancher/k3s/k3s.yaml
3. cp /etc/rancher/k3s/k3s.yaml ~/.kube/config
