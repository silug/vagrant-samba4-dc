yumrepo { 'steve-samba4-dc':
  ensure              => present,
  descr               => 'Copr repo for samba4-dc owned by steve',
  enabled             => true,
  skip_if_unavailable => true,
  gpgcheck            => '1',
  repo_gpgcheck       => '0',
  gpgkey              => 'https://copr-be.cloud.fedoraproject.org/results/steve/samba4-dc/pubkey.gpg',
  priority            => '1',
  baseurl             => 'https://copr-be.cloud.fedoraproject.org/results/steve/samba4-dc/epel-7-$basearch/',
  target              => '/etc/yum.repos.d/steve-samba4-dc-epel-7.repo',
} ->
package { 'yum-plugin-priorities':
  ensure => installed,
} ->
package { [
    'ctdb',
    'libsmbclient',
    'libwbclient',
    'samba',
    'samba-client',
    'samba-client-libs',
    'samba-common-libs',
    'samba-common-tools',
    'samba-dc',
    'samba-dc-libs',
    'samba-libs',
    'samba-python',
    'samba-vfs-glusterfs',
    'samba-winbind',
    'samba-winbind-clients',
    'samba-winbind-krb5-locator',
    'samba-winbind-modules',
    'expect',
    'rsync',
  ]:
  ensure => installed,
}

resources { 'host':
  purge => true,
}

host { 'localhost':
  ip           => '127.0.0.1',
  host_aliases => 'localhost.localdomain',
}

host { 'localhost6':
  ip           => '::1',
  host_aliases => 'localhost6.localdomain6',
}

host { $fqdn:
  ip           => $ipaddress,
  host_aliases => $hostname,
}
