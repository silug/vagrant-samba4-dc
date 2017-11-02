#!/bin/bash

set -e

adminpass="$1"
echo "Using $adminpass for administrator password." >&2

domain=$( dnsdomainname )
realm=${domain^^*}
ntdomain=${realm%%.*}

echo "Using realm=$realm and domain=$ntdomain." >&2

# setenforce 0

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

( set +e
while [ -z "$dc2" ] ; do
    dc2=$( nmblookup dc2 )
    if [ $? -eq 0 ] ; then
        dc2=${dc2%% *}
    else
        dc2=''
        logger "Waiting for dc2..."
        sleep 30
    fi
done
set -e

echo "nameserver $dc2" >> /etc/resolv.conf ) & disown %1

# while ! realm discover "$domain" ; do
#     echo "Failed to discover realm $domain. Trying again in 10 seconds."
#     sleep 10
# done

# echo "$adminpass" | realm join --membership-software=adcli "$domain"
# cp -fv /var/lib/samba/private/krb5.conf /etc/krb5.conf
# systemctl restart sssd
