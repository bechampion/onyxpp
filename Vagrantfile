# Example 4
#
# Single box with Apache and sample static site installed via Puppet.
#
# NOTE: Make sure you have the precise32 base box installed...
# vagrant box add precise32 http://files.vagrantup.com/precise32.box

Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/trusty64"
  config.vm.hostname = "onyx.dev"
  config.vm.synced_folder "static/", "/static/"
  config.vm.network "Rails default port", guest: 3000, host: 3000


  config.vm.provider :virtualbox do |vb|
    vb.customize [
      "modifyvm", :id,
      "--cpuexecutioncap", "50",
      "--memory", "1024",
    ]
  end
  config.vm.provision "shell" do |s|
   	s.path = "puppet/prep.sh"
  end
  config.vm.provision :puppet do |puppet|
    puppet.manifests_path = "puppet/manifests"
    puppet.manifest_file = "init.pp"
    puppet.module_path= "puppet/modules/"
	puppet.hiera_config_path = "puppet/hiera.yaml"
  end
end
