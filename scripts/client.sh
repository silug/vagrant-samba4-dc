#!/bin/bash

set -e

yum --nogpgcheck -y install \
    http://yum.puppetlabs.com/puppet5/puppet5-release-el-7.noarch.rpm \
    http://download.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
yum -y install puppet-agent

. /etc/profile.d/puppet-agent.sh

puppet resource package samba-client ensure=installed

domain="$( facter domain )"
declare -A dc
dc=([dc1]='' [dc2]='')

set +e
for n in "${!dc[@]}" ; do
    while [ -z "${dc[$n]}" ] ; do
        thisdc=$( nmblookup $n )
        if [ $? -eq 0 ] ; then
            dc[$n]=${thisdc%% *}
        else
            echo "Waiting for $n..." >&2
            sleep 30
        fi
    done
done
set -e

echo -e "search $domain" > /etc/resolv.conf
for n in "${!dc[@]}" ; do
    echo "nameserver ${dc[$n]}" >> /etc/resolv.conf
done

yum -y install \
    realmd \
    adcli \
    sssd \
    krb5-workstation \
    oddjob \
    oddjob-mkhomedir 

while ! realm discover "$domain" ; do
    echo "Failed to discover realm $domain. Trying again in 10 seconds."
    sleep 10
done

echo "$1" | realm join --membership-software=adcli "$domain"
