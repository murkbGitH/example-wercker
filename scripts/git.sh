#!/bin/bash -eux

: ${ius_release_url:?}

# add ius repo
yum -y install "${ius_release_url}"

# disable ius repo (require yum-utils)
yum-config-manager --disable ius > /dev/null

# install git
yum -y --enablerepo=ius install git2u
