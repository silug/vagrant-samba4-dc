#!/bin/bash

set -e

. /etc/profile.d/puppet-agent.sh

domain=$( facter domain )
domain_lc=${domain,,}
domain_uc=${domain^^}

cat >> /etc/krb5.conf <<END_KRB5_CONF

[realms]
 $domain_uc = {
 }

[domain_realm]
 $domain_lc = $domain_uc
 .$domain_lc = $domain_uc
END_KRB5_CONF

umask 077

cat > /etc/sssd/sssd.conf <<END_SSSD_CONF

[sssd]
domains = $domain_lc
config_file_version = 2
services = nss, pam

[domain/$domain_lc]
ad_domain = $domain_lc
krb5_realm = $domain_uc
realmd_tags = manages-system joined-with-samba
cache_credentials = True
id_provider = ad
krb5_store_password_if_offline = True
default_shell = /bin/bash
ldap_id_mapping = True
use_fully_qualified_names = False
fallback_homedir = /home/%u
access_provider = ad
krb5_keytab = /var/lib/samba/private/secrets.keytab
END_SSSD_CONF

systemctl restart sssd
