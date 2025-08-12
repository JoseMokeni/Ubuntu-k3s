Vagrant.configure("2") do |config|
  config.vm.box = "bento/ubuntu-24.04"
  config.vm.network "private_network", ip: "192.168.33.10"
  config.vm.synced_folder "./shared", "/shared"
  config.vm.hostname = "k3s-node" # Set the hostname inside the guest OS

  config.vm.provider "virtualbox" do |vb|
    vb.gui = false
    vb.memory = "8192"
    vb.cpus = 6
    vb.name = "ubuntu-k3s-24-04"
  end

  # provision the VM with a shell script
  config.vm.provision "shell", path: "provision.sh"
  config.vm.provision "shell", path: "user-provision.sh", privileged: false
end
