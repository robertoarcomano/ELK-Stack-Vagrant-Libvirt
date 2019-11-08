Vagrant.configure("2") do |config|
  config.vm.synced_folder ".", "/vagrant"
  config.vm.box = "generic/ubuntu1804"
  config.vm.hostname = "elkhost"
  config.vm.provider :libvirt do |libvirt|
    libvirt.memory = 8192
    libvirt.cpus   = 4
  end
  config.vm.provision "shell" do |s|
    s.path = "provision_script.sh"
  end
end
