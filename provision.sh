apt-get update
apt-get install -y git curl

# Install k3s
curl -sfL https://get.k3s.io | sh -

# Wait for k3s to be ready
systemctl enable k3s
systemctl start k3s

# Set up kubectl access for vagrant user
mkdir -p /home/vagrant/.kube
cp /etc/rancher/k3s/k3s.yaml /home/vagrant/.kube/config
chown -R vagrant:vagrant /home/vagrant/.kube
chmod 600 /home/vagrant/.kube/config

# Add kubectl alias and k3s config to .bashrc
echo 'export KUBECONFIG=/home/vagrant/.kube/config' >> /home/vagrant/.bashrc
echo 'alias k=kubectl' >> /home/vagrant/.bashrc