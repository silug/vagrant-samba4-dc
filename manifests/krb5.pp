# @summary Prep krb5 configuration
# @param conf Path to krb5.conf
# @param settings Settings to add to krb5.conf
class samba4_dc::krb5 (
  String $conf     = '/etc/krb5.conf',
  Hash   $settings = {
    'default_realm'    => {
      'path'    => $conf,
      'section' => 'libdefaults',
      'setting' => 'default_realm',
      'value'   => $facts['domain'].upcase,
    },
    'dns_lookup_realm' => {
      'path'    => $conf,
      'section' => 'libdefaults',
      'setting' => 'dns_lookup_realm',
      'value'   => false,
    },
    'dns_lookup_kdc'   => {
      'path'    => $conf,
      'section' => 'libdefaults',
      'setting' => 'dns_lookup_kdc',
      'value'   => true,
    }
  },
) {
  $settings.each |$key, $value| {
    ini_setting { $key:
      * => $value,
    }
  }
}
