#!/bin/bash

set -e

dc1=''
domain="$( dnsdomainname )"

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

# setenforce 0

rm -fv /etc/samba/smb.conf
samba-tool domain join "$realm" DC \
    -U "$realm\\administrator" \
    --dns-backend=BIND9_DLZ \
    --password="$adminpass"

echo $'Host dc1\n  StrictHostKeyChecking no' >> /root/.ssh/config
rsync -zavHPXA dc1:/var/lib/samba/sysvol/. /var/lib/samba/sysvol/.

puppet resource service samba ensure=running enable=true

sed -i \
    -e '/^[[:space:]]*listen-on/s/{[^}]*}/{ any; }/' \
    -e '/^[[:space:]]*allow-query/{ s/{[^}]*}/{ any; }/;p;s/query/recursion/; }' \
    -e $'$a include "/var/lib/samba/bind-dns/named.conf"\;\n' \
    /etc/named.conf
chcon -t named_conf_t /var/lib/samba/bind-dns/named.conf
puppet resource service named ensure=running enable=true

echo "nameserver 0.0.0.0" >> /etc/resolv.conf

# while ! realm discover "$domain" ; do
#     echo "Failed to discover realm $domain. Trying again in 10 seconds."
#     sleep 10
# done

# echo "$adminpass" | realm join --membership-software=adcli "$domain"
# cp -fv /var/lib/samba/private/krb5.conf /etc/krb5.conf
# systemctl restart sssd
