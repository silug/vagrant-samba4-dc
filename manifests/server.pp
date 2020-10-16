$packages = [
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
]

$hosts = {
  'localhost'    => {
    'ip'           => '127.0.0.1',
    'host_aliases' => 'localhost.localdomain',
  },
  'localhost6'   => {
    'ip'           => '::1',
    'host_aliases' => 'localhost6.localdomain6',
  },
  $facts['fqdn'] => {
    'ip'           => $facts['ipaddress'],
    'host_aliases' => $facts['hostname'],
  },
}

$ini_settings = {
  'default_realm'    => {
    'path'    => '/etc/krb5.conf',
    'section' => 'libdefaults',
    'setting' => 'default_realm',
    'value'   => $facts['domain'].upcase,
  },
  'dns_lookup_realm' => {
    'path'    => '/etc/krb5.conf',
    'section' => 'libdefaults',
    'setting' => 'dns_lookup_realm',
    'value'   => false,
  },
  'dns_lookup_kdc'   => {
    'path'    => '/etc/krb5.conf',
    'section' => 'libdefaults',
    'setting' => 'dns_lookup_kdc',
    'value'   => true,
  }
}

package { $packages:
  ensure => installed,
}

resources { 'host':
  purge => true,
}

$hosts.each |$key, $value| {
  host { $key:
    * => $value,
  }
}

$ini_settings.each |$key, $value| {
  ini_setting { $key:
    * => $value,
  }
}
