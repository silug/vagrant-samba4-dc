# -*- mode: ruby -*-
# vi: set ft=ruby ai et sw=2 :

adminpass='aMs]doam9pqxh0Ub'

Vagrant.configure(2) do |config|
  config.vm.box = "centos/7"

  config.vm.define "dc1" do |dc1|
    dc1.vm.hostname = "dc1.samba4.local"
    dc1.vm.provision :shell,
      :path => "scripts/server.sh"
    dc1.vm.provision :shell,
      :path => "scripts/provision.sh",
      :args => [ adminpass ]
  end

  config.vm.define "dc2" do |dc2|
    dc2.vm.hostname = "dc2.samba4.local"
    dc2.vm.provision :shell,
      :path => "scripts/server.sh"
    dc2.vm.provision :shell,
      :path => "scripts/secondary.sh",
      :args => [ adminpass ]
  end

  config.vm.define "client" do |client|
    client.vm.hostname = "client.samba4.local"
    client.vm.provision :shell,
      :path => "scripts/client.sh",
      :args => [ adminpass ]
  end
end
