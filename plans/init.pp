# @summary Build a Samba Active Directory domain
# @param adminpass Domain Administrator password
# @param targets The targets to run on
plan samba4_dc (
  String     $adminpass,
  TargetSpec $targets = 'all',
) {
  # Install puppet-agent and collect facts.
  apply_prep($targets)

  $all_targets = get_targets($targets)
  $dcs = $all_targets.reduce([]) |$memo, $target| {
    if $target.facts['hostname'] =~ /dc[0-9]+(?:[a-z])*$/ {
      $memo + $target
    } else {
      $memo
    }
  }
  $clients = get_targets($targets) - $dcs

  out::message("Provisioning on ${dcs[0]}")
  out::message("Domain controllers: ${dcs}")
  out::message("Clients: ${clients}")

  # Use the collected facts to build a hash of `host` resources.
  $hosts = get_targets($targets).reduce({}) |$memo, $target| {
    $this_host = {
      $target.facts['fqdn'] => {
        'ip' => $target.facts['networking']['interfaces'].reduce('') |$m, $v| {
          if $v[0] =~ /^e/ and $v[1]['ip'] {
            $v[1]['ip']
          } else {
            $m
          }
        },
        'host_aliases' => [
          $target.facts['hostname'],
        ],
      },
    }
    $memo + $this_host
  }

  # Use the hash to configure the hosts file on each target.
  apply($targets, '_description' => 'Configure hosts file') {
    $hosts.each |$key, $value| {
      host { $key:
        * => $value,
      }
    }
  }

  # Install packages and set up base configuration.
  apply($dcs, '_description' => 'Prep domain controllers') {
    include samba4_dc::haveged
    include samba4_dc::install
    include samba4_dc::krb5

    Class['samba4_dc::haveged']
    -> Class['samba4_dc::install']
    -> Class['samba4_dc::krb5']
  }

  run_command('rm -fv /var/lib/sss/db/*', $dcs, 'Remove sssd db')

  # Generate ssh keys on domain controllers for password-less rsync over ssh.
  apply($dcs, '_description' => 'Generate ssh keys') {
    exec { 'ssh-keygen -f /root/.ssh/id_rsa -t rsa -b 4096 -N ""':
      path    => '/bin:/usr/bin',
      creates => '/root/.ssh/id_rsa.pub',
    }
    -> file { '/tmp/id_rsa.pub':
      ensure => file,
      source => '/root/.ssh/id_rsa.pub',
    }
  }
  download_file('/tmp/id_rsa.pub', 'sshkeys', $dcs)

  # Configure password-less rsync over ssh.
  out::message('Collect keys and configure authorized keys')
  $dcs.parallelize |$dc| {
    $ssh_keys = ($dcs - get_target($dc)).reduce({}) |$memo, $target| {
      $key = file::read("${system::env('PWD')}/downloads/sshkeys/${get_target($target)}/id_rsa.pub").split(/\s+/)
      $memo + {
        $key[2] => {
          'ensure'  => 'present',
          'type'    => $key[0],
          'key'     => $key[1],
          'user'    => 'root',
          'options' => [
            "from=\"${$target.facts['fqdn']},${hosts[$target.facts['fqdn']]['ip']}\"",
            'command="/usr/bin/rsync ${SSH_ORIGINAL_COMMAND#* }"',
            'no-port-forwarding',
            'no-X11-forwarding',
            'no-agent-forwarding',
            'no-pty',
          ],
        },
      }
    }

    apply($dc) {
      $ssh_keys.each |$key, $value| {
        ssh_authorized_key { $key:
          * => $value,
        }
      }
    }
  }

  # Configure domain
  run_script('samba4_dc/provision.sh', $dcs[0], 'arguments' => [$adminpass])
  run_script(
    'samba4_dc/secondary.sh',
    $dcs - [$dcs[0]],
    'arguments' => [
      $adminpass,
      $hosts[$dcs[0].facts['fqdn']]['ip'],
    ],
  )
  run_script('samba4_dc/sssd.sh', $dcs)

  # Update resolv.conf on all hosts
  apply($targets, '_description' => 'Update resolver on all hosts') {
    class { 'dnsclient':
      domain      => $dcs[0].facts['domain'],
      nameservers => $dcs.map |$target| { $hosts[$target.facts['fqdn']]['ip'] },
    }
  }

  # Configure clients
  run_script('samba4_dc/client.sh', $clients, 'arguments' => [$adminpass])
}
