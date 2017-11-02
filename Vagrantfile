# -*- mode: ruby -*-
# vi: set ft=ruby ai et sw=2 :

adminpass = ENV['ADMINPASS'] || 'aMs]doam9pqxh0Ub'
ip_subnet = ENV['IP_SUBNET'] || '192.168.42'

Vagrant.configure(2) do |config|
  ['virtualbox', 'libvirt'].each do |provider|
    config.vm.provider provider do |p|
      p.memory = '1024'
    end
  end

  config.vm.define "dc1" do |dc1|
    dc1.vm.box = "fedora/32-cloud-base"
    dc1.vm.hostname = "dc1.samba4.local"

    dc1.vm.provider :virtualbox do |vb|
      vb.memory = "1024"
      vb.name = "dc1.samba4.local"
    end

    dc1.vm.provider :libvirt do |libvirt|
      libvirt.memory = "1024"
      libvirt.qemu_use_session = false
    end

    dc1.vm.network :private_network,
      :ip => "#{ip_subnet}.101"
    dc1.vm.provision :shell,
      :path => "scripts/server.sh"
    dc1.vm.provision :shell,
      :path => "scripts/provision.sh",
      :args => [ adminpass ]
    dc1.vm.provision :shell,
      :path => "scripts/sssd.sh"
  end

  config.vm.define "dc2" do |dc2|
    dc2.vm.box = "fedora/32-cloud-base"
    dc2.vm.hostname = "dc2.samba4.local"

    dc2.vm.provider :virtualbox do |vb|
      vb.memory = "1024"
      vb.name = "dc1.samba4.local"
    end

    dc2.vm.provider :libvirt do |libvirt|
      libvirt.memory = "1024"
      libvirt.qemu_use_session = false
    end

    dc2.vm.network :private_network,
      :ip => "#{ip_subnet}.102"
    dc2.vm.provision :shell,
      :path => "scripts/server.sh"
    dc2.vm.provision :shell,
      :path => "scripts/secondary.sh",
      :args => [ adminpass ]
    dc2.vm.provision :shell,
      :path => "scripts/sssd.sh"
  end

  config.vm.define "client" do |client|
    client.vm.box = "centos/8"
    client.vm.hostname = "client.samba4.local"

    client.vm.provider :virtualbox do |vb|
      vb.name = "client.samba4.local"
    end

    client.vm.provider :libvirt do |libvirt|
      libvirt.qemu_use_session = false
    end
    client.vm.network :private_network,
      :ip => "#{ip_subnet}.8"
    client.vm.provision :shell,
      :path => "scripts/client.sh",
      :args => [ adminpass ]
  end
end
