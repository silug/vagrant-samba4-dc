# @summary Set up haveged to speed up ssh key generation
class samba4_dc::haveged {
  package { 'haveged':
    ensure => installed,
  }
  -> service { 'haveged':
    ensure => running,
    enable => true,
  }
}
