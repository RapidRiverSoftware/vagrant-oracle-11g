# -*- mode: ruby -*-
# vi: set ft=ruby :

disk_dir = File.join(File.dirname(File.expand_path(__FILE__)), 'tmp')
Dir::mkdir(disk_dir) unless ::File.directory?(disk_dir)

Vagrant.configure("2") do |config|

  config.vm.box = "oraclelinux-6-x86_64"
  config.vm.box_url = "http://cloud.terry.im/vagrant/oraclelinux-6-x86_64.box"
  config.vm.hostname = "oracle"

  config.ssh.forward_x11=true

  # Forward Oracle ports
  config.vm.network :forwarded_port, guest: 1521, host: 1521
  config.vm.network :forwarded_port, guest: 1158, host: 1158

  large_oracle_disk = File.join(disk_dir, 'oracle.vdi')

  config.vm.provider :virtualbox do |vb|
    vb.customize ['createhd', '--filename', large_oracle_disk, '--size', 20 * 1024] unless File.exist?(large_oracle_disk)
    vb.customize ['storageattach', :id, '--storagectl', 'SATA', '--port', 1, '--device', 0, '--type', 'hdd', '--medium', large_oracle_disk]
    vb.customize ["modifyvm", :id,
                  "--name", "oradb",
                  "--memory", "2048",
                  "--natdnshostresolver1", "on"]
  end

  # config.vm.provision :shell, :inline => "cd /opt/VBoxGuestAdditions-*/init && ./vboxadd setup"

  config.vm.provision :shell, path: "bootstrap.sh"

  config.vm.provision :shell, :inline => "sudo rm /etc/localtime && sudo ln -s /usr/share/zoneinfo/US/Eastern /etc/localtime"

  config.vm.provision :shell, :inline => "sudo yum install puppet -y"

  config.vm.synced_folder '../webstats-pg-reporting/data', '/webstats-pg-reporting/data'

  # config.vbguest.auto_update = false

  config.vm.provision :puppet do |puppet|
    puppet.manifests_path = "manifests"
    puppet.module_path = "modules"
    puppet.manifest_file = "base.pp"
    puppet.options = "--verbose --trace"
  end
end
