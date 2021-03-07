#!/bin/bash

set -e

. /etc/profile.d/puppet-agent.sh

puppet resource package samba-client ensure=installed

domain="$( facter domain )"

yum -y install \
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
