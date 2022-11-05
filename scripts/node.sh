#! /bin/bash

NODENAME=$(hostname -s)

# Join the control node
/bin/bash /vagrant/configs/join.sh -v

# KUBECONFIG for in-VM kubectl usage
sudo -i -u vagrant bash << EOF
mkdir -p /home/vagrant/.kube
sudo cp -i /vagrant/configs/config /home/vagrant/.kube/
sudo chown 1000:1000 /home/vagrant/.kube/config
kubectl label node $(hostname -s) node-role.kubernetes.io/worker=worker-new
EOF
