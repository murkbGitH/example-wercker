#!/bin/bash -eux

vagrant_user="vagrant"
vagrant_pubkey_url="https://raw.githubusercontent.com/mitchellh/vagrant/master/keys/vagrant.pub"

# sudoers
touch /etc/sudoers.d/wheel
chmod 0440 /etc/sudoers.d/wheel
tee <<EOS /etc/sudoers.d/wheel
%wheel ALL=(ALL) NOPASSWD: ALL
Defaults:%wheel env_keep += SSH_AUTH_SOCK
Defaults:%wheel !requiretty
Defaults:%root  !requiretty
EOS

# user add
useradd -m -g wheel "$vagrant_user"

# set password
echo vagrant | passwd --stdin "$vagrant_user"

# home directory
vagrant_home=$(eval echo \~"${vagrant_user}")

# authorized_keys
mkdir -p "$vagrant_home/.ssh"
curl -fsSL "$vagrant_pubkey_url" > "$vagrant_home/.ssh/authorized_keys"
chown -R "$vagrant_user:" "$vagrant_home/.ssh"
chmod 700 "$vagrant_home/.ssh"
chmod 600 "$vagrant_home/.ssh/authorized_keys"
