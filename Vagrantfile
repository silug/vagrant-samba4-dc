# -*- mode: ruby -*-
# vi: set ft=ruby ai et sw=2 :
ENV['VAGRANT_EXPERIMENTAL'] = 'typed_triggers'

adminpass  = ENV['SAMBA4_ADMINPASS']  || 'aMs]doam9pqxh0Ub'
ip_subnet  = ENV['SAMBA4_IP_SUBNET']  || '192.168.42'
dc_box     = ENV['SAMAB4_DC_BOX']     || 'fedora/34-cloud-base'
client_box = ENV['SAMAB4_CLIENT_BOX'] || 'centos/stream8'
domain     = ENV['SAMBA4_DOMAIN']     || 'samba4.local'
dc_count   = ENV['SAMBA4_DC_COUNT']   || 2

Vagrant.configure(2) do |config|
  ['virtualbox', 'libvirt'].each do |provider|
    config.vm.provider provider do |p|
      p.memory = '1024'
      p.qemu_use_session = false if provider == 'libvirt'
    end
  end

  config.vm.synced_folder '.', '/vagrant', disabled: true

  (1..dc_count).each do |n|
    config.vm.define "dc#{n}" do |dc|
      dc.vm.box = dc_box
      dc.vm.hostname = "dc#{n}.#{domain}"

      dc.vm.provider :virtualbox do |vb|
        vb.name = "dc#{n}.#{domain}"
      end

      dc.vm.network :private_network,
        ip: "#{ip_subnet}.#{100 + n}"
    end
  end

  config.vm.define 'client' do |client|
    client.vm.box = client_box
    client.vm.hostname = "client.#{domain}"

    client.vm.provider :virtualbox do |vb|
      vb.name = "client.#{domain}"
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
