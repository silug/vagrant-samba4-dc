#!/bin/bash

set -e

. /etc/profile.d/puppet-agent.sh

adminpass="$1"
echo "Using $adminpass for administrator password." >&2

dc1="$2"
domain="$( dnsdomainname )"

echo -e "search $domain\nnameserver $dc1" > /etc/resolv.conf

realm="${domain^^*}"

echo "Using realm=$realm." >&2

rm -fv /etc/samba/smb.conf
samba-tool domain join "$realm" DC \
    -U "$realm\\administrator" \
    --dns-backend=BIND9_DLZ \
    --password="$adminpass"

echo -e "Host $dc1\\n  StrictHostKeyChecking no" >> /root/.ssh/config
rsync -zavHPXA $dc1:/var/lib/samba/sysvol/. /var/lib/samba/sysvol/.

puppet resource service samba ensure=running enable=true

sed -i \
    -e '/^[[:space:]]*listen-on/s/{[^}]*}/{ any; }/' \
    -e '/^[[:space:]]*allow-query/{ s/{[^}]*}/{ any; }/;p;s/query/recursion/; }' \
    -e $'$a include "/var/lib/samba/bind-dns/named.conf"\;\n' \
    /etc/named.conf
chcon -t named_conf_t /var/lib/samba/bind-dns/named.conf
puppet resource service named ensure=running enable=true

echo "nameserver 0.0.0.0" >> /etc/resolv.conf
