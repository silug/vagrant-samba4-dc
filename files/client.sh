#!/bin/bash

set -e

. /etc/profile.d/puppet-agent.sh

domain="$( facter domain )"

yum -y install \
    samba-client \
    realmd \
    adcli \
    sssd \
    krb5-workstation \
    oddjob \
    oddjob-mkhomedir

echo "$1" | realm join --membership-software=adcli "$domain"

sed -i \
    -e '/^use_fully_qualified_names\>/s/True/False/' \
    -e '/^fallback_homedir\>/s/@.*$//' \
    /etc/sssd/sssd.conf

systemctl restart sssd.service
