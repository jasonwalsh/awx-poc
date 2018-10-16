Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/xenial64"
  config.vm.provision "ansible_local" do |ansible|
    # https://www.vagrantup.com/docs/provisioning/ansible_local.html#install-galaxy-roles-in-a-path-owned-by-root
    ansible.become = true
    ansible.galaxy_command = "sudo ansible-galaxy install --role-file=%{role_file} --roles-path=%{roles_path} --force"
    ansible.galaxy_role_file = "provisioning/requirements.yml"
    ansible.galaxy_roles_path = "/etc/ansible/roles"
    ansible.playbook = "provisioning/playbook.yml"
  end
end
