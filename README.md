This demonstrates a simple [Samba 4](https://www.samba.org/) Active Directory
proof-of-concept with two domain controllers and a single client.

The two domain controllers run
[Fedora 32](https://app.vagrantup.com/fedora/boxes/32-cloud-base),
and the client runs [CentOS 8](https://atlas.hashicorp.com/centos/boxes/8).
The two domain controllers are using the stock Fedora packages.

To test, simply do the following on a system with git and vagrant installed:

    git clone https://github.com/silug/vagrant-samba4-dc.git
    cd vagrant-samba4-dc
    vagrant up
