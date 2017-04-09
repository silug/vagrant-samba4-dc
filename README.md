This demonstrates a simple [Samba 4](https://www.samba.org/) Active Directory
proof-of-concept with two domain controllers and a single client.

All three systems run [CentOS 7](https://atlas.hashicorp.com/centos/boxes/7).
The two domain controllers are using the packages from
[this copr repository](https://copr.fedorainfracloud.org/coprs/steve/samba4-dc/)
(more information can be found on
[GitHub](https://github.com/silug/samba4-dc-rpm).

To test, simply do the following on a system with git and vagrant installed:

    git clone https://github.com/silug/vagrant-samba4-dc.git
    cd vagrant-samba4-dc
    vagrant up
