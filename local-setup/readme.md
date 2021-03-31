# Docker installation - https://docs.docker.com/engine/install/ubuntu/
sudo apt-get remove docker docker-engine docker.io containerd runc
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io
# docker test - https://docs.docker.com/engine/install/ubuntu/
sudo docker run hello-world
# docker without sudo - https://www.configserverfirewall.com/ubuntu-linux/add-user-to-docker-group-ubuntu/
grep docker /etc/group
usermod -aG docker $USER

# kubectl installation - https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
kubectl version --client

# kind installation - https://kind.sigs.k8s.io/docs/user/quick-start#installation
curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.10.0/kind-linux-amd64
chmod +x ./kind
mv ./kind ~/bin/kind

# vpn killswitch disabling for docker, kind networks
ip addr | grep inet
    # choose docker, kind (br-xxxx) networks ip blocks
sudo ufw allow in to {ip-block}
sudo ufw allow out to {ip-block}

# Helm installation - https://helm.sh/docs/intro/install/
sudo snap install helm --classic

# kind creating cluster - https://kind.sigs.k8s.io/docs/user/ingress
kind create cluster --config kind-cluster-config.yaml --name tada

# kind ingress setup - https://kind.sigs.k8s.io/docs/user/ingress
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/static/provider/kind/deploy.yaml
kubectl wait --namespace ingress-nginx --for=condition=ready pod --selector=app.kubernetes.io/component=controller --timeout=90s

# setup jenkins
k apply -f namespace.yaml
k apply -f storageClass.yaml
k apply -f persistenceVolume.yaml
k apply -f persistenceVolumeClaim.yaml
helm repo add jenkins https://charts.jenkins.io         #https://github.com/jenkinsci/helm-charts
helm install jenkins jenkins/jenkins --namespace jenkins -f values.yaml

# update /etc/hosts
sudo vi /etc/hosts
add if not exists in the file, 127.0.0.1	jenkins.datalabs.tapestry.com

# uninstall jenkins
helm uninstall jenkins --namespace jenkins

# metric server for k8s
kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml
kubectl get deployment metrics-server -n kube-system

# debug
k get pods -n jenkins
k describe pods jenkins-0 -n jenkins