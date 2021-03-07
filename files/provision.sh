#!/bin/bash

set -e

. /etc/profile.d/puppet-agent.sh

adminpass="$1"
echo "Using $adminpass for administrator password." >&2

domain=$( dnsdomainname )
realm=${domain^^*}
ntdomain=${realm%%.*}

echo "Using realm=$realm and domain=$ntdomain." >&2

rm -fv /etc/samba/smb.conf
samba-tool domain provision \
    --domain="$ntdomain" \
    --realm="$realm" \
    --server-role=dc \
    --dns-backend=BIND9_DLZ \
    --use-rfc2307 \
    --adminpass="$adminpass"

cp -fv /var/lib/samba/private/krb5.conf /etc/krb5.conf
sed -i -e '/^nameserver/s/\s\+.*$/ 0.0.0.0/' /etc/resolv.conf

puppet resource service samba ensure=running enable=true

sed -i \
    -e '/^[[:space:]]*listen-on/s/{[^}]*}/{ any; }/' \
    -e '/^[[:space:]]*allow-query/{ s/{[^}]*}/{ any; }/;p;s/query/recursion/; }' \
    -e $'$a include "/var/lib/samba/bind-dns/named.conf"\;\n' \
    /etc/named.conf
chcon -t named_conf_t /var/lib/samba/bind-dns/named.conf
puppet resource service named ensure=running enable=true
