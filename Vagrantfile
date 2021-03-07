# -*- mode: ruby -*-
# vi: set ft=ruby ai et sw=2 :
ENV['VAGRANT_EXPERIMENTAL'] = 'typed_triggers'

adminpass = ENV['ADMINPASS'] || 'aMs]doam9pqxh0Ub'
ip_subnet = ENV['IP_SUBNET'] || '192.168.42'

Vagrant.configure(2) do |config|
  ['virtualbox', 'libvirt'].each do |provider|
    config.vm.provider provider do |p|
      p.memory = '1024'
    end
  end

  config.vm.synced_folder '.', '/vagrant', disabled: true

  config.vm.define "dc1" do |dc1|
    dc1.vm.box = "fedora/32-cloud-base"
    dc1.vm.hostname = "dc1.samba4.local"

    dc1.vm.provider :virtualbox do |vb|
      vb.name = "dc1.samba4.local"
    end

    dc1.vm.provider :libvirt do |libvirt|
      libvirt.qemu_use_session = false
    end

    dc1.vm.network :private_network,
      ip: "#{ip_subnet}.101"
  end

  config.vm.define "dc2" do |dc2|
    dc2.vm.box = "fedora/32-cloud-base"
    dc2.vm.hostname = "dc2.samba4.local"

    dc2.vm.provider :virtualbox do |vb|
      vb.name = "dc1.samba4.local"
    end

    dc2.vm.provider :libvirt do |libvirt|
      libvirt.qemu_use_session = false
    end

    dc2.vm.network :private_network,
      ip: "#{ip_subnet}.102"
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
      ip: "#{ip_subnet}.8"
  end

  config.trigger.before [:up, :provision, :reload], type: :command do |trigger|
    trigger.info = 'Initializing bolt'
    trigger.run = { inline: 'bolt module install' }
  end

  config.trigger.after [:up, :provision, :reload], type: :command do |trigger|
    trigger.info = 'Running bolt plan'
    trigger.run = {
      inline: [
        'bolt plan run samba4_dc --run-as root --verbose',
        "adminpass=#{adminpass}",
      ].join(' '),
    }
  end
end
