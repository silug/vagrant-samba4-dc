# @summary Prep server packages
# @param packages Packages to install on the server
class samba4_dc::install (
  Array $packages = [
    'samba-dc-bind-dlz',
    'samba-dc',
    'samba-client',
    'bind',
    'krb5-workstation',
    'expect',
    'rsync',
    'realmd',
    'adcli',
    'sssd',
    'oddjob-mkhomedir',
    'oddjob',
  ],
) {
  package { $packages:
    ensure => installed,
  }
}
