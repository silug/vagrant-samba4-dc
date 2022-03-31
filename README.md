This demonstrates a simple [Samba 4](https://www.samba.org/) Active Directory
proof-of-concept with two domain controllers and a single client.

The two domain controllers run
[Fedora 34](https://app.vagrantup.com/fedora/boxes/34-cloud-base),
and the client runs [CentOS Stream 8](https://app.vagrantup.com/centos/boxes/stream8).
The two domain controllers are using the stock Fedora packages.

To test, simply do the following on a system with Git,
[Bolt](https://puppet.com/docs/bolt/latest/bolt.html),
[Vagrant](https://vagrantup.com/), and a Vagrant provider
([VirtualBox](https://www.virtualbox.org/) or libvirt) installed:

    git clone https://github.com/silug/vagrant-samba4-dc.git
    cd vagrant-samba4-dc
    vagrant up
