#! /bin/bash
set -e

echo "This is Master"
apt-get update
apt-get install -y apt-transport-https ca-certificates curl software-properties-common

echo "############## Docker installation "
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
apt-get -y update && apt-get install -y containerd.io=1.2.10-3 docker-ce=5:19.03.4~3-0~ubuntu-$(lsb_release -cs) \
  docker-ce-cli=5:19.03.4~3-0~ubuntu-$(lsb_release -cs)

cat > /etc/docker/daemon.json <<EOF
{
  "exec-opts": ["native.cgroupdriver=systemd"],
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "100m"
  },
  "storage-driver": "overlay2"
}
EOF

mkdir -p /etc/systemd/system/docker.service.d
systemctl daemon-reload
systemctl restart docker


echo "############## Installing Kubernertes and starting master node"
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
cat <<EOF | sudo tee /etc/apt/sources.list.d/kubernetes.list
deb https://apt.kubernetes.io/ kubernetes-xenial main
EOF
apt-get update
apt-get install -y kubelet kubeadm kubectl
apt-mark hold kubelet kubeadm kubectl

swapoff -a
sudo sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab

#IP of this box
IP_ADDR=`ifconfig eth1 | grep netmask | awk '{print $2}' | cut -f2 -d:`

kubeadm init --apiserver-advertise-address=$IP_ADDR --pod-network-cidr=192.168.0.0/16

echo "########### Copy Kubeconfig file"
sudo --user=vagrant mkdir -p /home/vagrant/.kube
sudo cp -i /etc/kubernetes/admin.conf /home/vagrant/.kube/config
sudo chown $(id -u vagrant):$(id -g vagrant) /home/vagrant/.kube/config
sudo cp /home/vagrant/.kube/config /vagrant/vagrantKubeConfig

echo "###########  apply calico network"
export KUBECONFIG=/etc/kubernetes/admin.conf
kubectl apply -f https://docs.projectcalico.org/v3.8/manifests/calico.yaml

echo "########### Creating join command"
kubeadm token create --print-join-command > /vagrant/join_command.sh
chmod +x /vagrant/join_command.sh
echo "########## Kubernetes master node has been setup"
