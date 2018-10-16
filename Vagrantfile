Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/xenial64"
  config.vm.network "forwarded_port", guest: 80, host: 8080
  config.vm.provider "virtualbox" do |virtualbox|
    virtualbox.memory = 4096
  end
  config.vm.provision "ansible_local" do |ansible|
    ansible.galaxy_role_file = "provisioning/requirements.yml"
    ansible.galaxy_roles_path = "/home/vagrant/.ansible/roles"
    ansible.playbook = "provisioning/playbook.yml"
  end
end
