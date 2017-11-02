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
