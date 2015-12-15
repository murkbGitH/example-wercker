#!/bin/bash -eux

# install virtualbox additions
mount -o loop VBoxGuestAdditions_$(cat .vbox_version).iso /mnt
/mnt/VBoxLinuxAdditions.run &&:

# cleanup
umount /mnt
rm -vf VBoxGuestAdditions_*.iso
