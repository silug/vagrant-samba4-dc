#!/bin/bash

set -e

if [ -d /vagrant/sync ] ; then
    vagrantsync=/vagrant/sync
elif [ -d /home/vagrant/sync ] ; then
    vagrantsync=/home/vagrant/sync
elif [ -d /vagrant ] ; then
    vagrantsync=/vagrant
else
    echo "Can't find sync directory!" >&2
    exit 1
fi

yum --nogpgcheck -y install \
    http://yum.puppet.com/puppet6-release-fedora-32.noarch.rpm
yum -y install puppet-agent

. /etc/profile.d/puppet-agent.sh

puppet module install puppetlabs-inifile
puppet apply "$vagrantsync"/manifests/server.pp
puppet apply "$vagrantsync"/manifests/ssh.pp

rm -fv /var/lib/sss/db/*
