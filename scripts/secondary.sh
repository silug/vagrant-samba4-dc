#!/bin/bash

set -e

dc1=''
domain="$( facter domain )"

set +e
while [ -z "$dc1" ] ; do
    dc1=$( nmblookup dc1 )
    if [ $? -eq 0 ] ; then
        dc1=${dc1%% *}
    else
        dc1=''
        echo "Waiting for dc1..." >&2
        sleep 30
    fi
done
set -e

echo -e "search $domain\nnameserver $dc1" > /etc/resolv.conf

adminpass="$1"
echo "Using $adminpass for administrator password." >&2

realm="${domain^^*}"

echo "Using realm=$realm." >&2

setenforce 0

cat > /etc/krb5.conf <<END
[libdefaults]
        default_realm = $realm
        dns_lookup_realm = false
        dns_lookup_kdc = true
END

rm -fv /etc/samba/smb.conf
samba-tool domain join "$realm" DC \
    -U "$realm\\administrator" \
    --dns-backend=SAMBA_INTERNAL \
    --password="$adminpass"

echo -e 'Host dc1\n  StrictHostKeyChecking no' >> /root/.ssh/config
rsync -zavHPXA dc1:/var/lib/samba/sysvol/. /var/lib/samba/sysvol/.

puppet resource service samba ensure=running enable=true

echo "nameserver 0.0.0.0" >> /etc/resolv.conf
