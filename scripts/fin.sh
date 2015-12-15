#!/bin/bash -eux

# root password reset
dd if=/dev/urandom count=50|md5sum|passwd --stdin root

# yum
yum clean all

# sshd
rm -vf /etc/ssh/ssh_host_*

# clean tmp
rm -vrf /tmp/*

# Zero out the free space to save space in the final image.
dd if=/dev/zero of=/EMPTY bs=1M &&:
rm -f /EMPTY
sync
