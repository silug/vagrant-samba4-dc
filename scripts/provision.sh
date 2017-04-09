#!/bin/bash

set -e

adminpass="$1"
echo "Using $adminpass for administrator password." >&2

realm=$( facter domain | tr '[:lower:]' '[:upper:]' )
domain=${realm%%.*}

echo "Using realm=$realm and domain=$domain." >&2

setenforce 0

> /etc/krb5.conf

rm -fv /etc/samba/smb.conf
samba-tool domain provision \
    --domain="$domain" \
    --realm="$realm" \
    --server-role=dc \
    --dns-backend=SAMBA_INTERNAL \
    --use-rfc2307 \
    --adminpass="$adminpass"

cp -fv /var/lib/samba/private/krb5.conf /etc/krb5.conf
sed -i -e '/^nameserver/s/\s\+.*$/ 0.0.0.0/' /etc/resolv.conf

puppet resource service samba ensure=running enable=true

set +e
while [ -z "$dc2" ] ; do
    dc2=$( nmblookup dc2 )
    if [ $? -eq 0 ] ; then
        dc2=${dc2%% *}
    else
        dc2=''
        echo "Waiting for dc2..." >&2
        sleep 30
    fi
done
set -e

echo -e "nameserver $dc2" >> /etc/resolv.conf
