#!/bin/bash -eux

releasever=$(rpm -qf /etc/redhat-release --qf='%{version}')

# ipv6
mkdir -p /etc/sysctl.d
tee <<EOS /etc/sysctl.d/ipv6-disable.conf
# ipv6 disable
net.ipv6.conf.all.disable_ipv6 = 1
net.ipv6.conf.default.disable_ipv6 = 1
EOS

case "$releasever" in
  7)
    # hostname
    rm -f /etc/hostname
    ;;
esac

# sshd_config
sed -i -r '/^#?UseDNS /c UseDNS no' /etc/ssh/sshd_config
sed -i -r '/^#?PermitRootLogin /c PermitRootLogin without-password' /etc/ssh/sshd_config
sed -i -r '/^#?AddressFamily /c AddressFamily inet' /etc/ssh/sshd_config

# postfix
postconf -e inet_protocols=ipv4

case "$releasever" in
  6)
    # chkconfig
    chkconfig auditd       off 2>/dev/null &&:
    chkconfig ip6tables    off 2>/dev/null &&:
    chkconfig iptables     off 2>/dev/null &&:
    chkconfig iscsi        off 2>/dev/null &&:
    chkconfig iscsid       off 2>/dev/null &&:
    chkconfig kdump        off 2>/dev/null &&:
    chkconfig lvm2-monitor off 2>/dev/null &&:
    chkconfig mdmonitor    off 2>/dev/null &&:

    # yum from epel
    yum -y install bash-completion
    ;;
  7)
    # systemd
    systemctl enable acpid.service
    systemctl disable auditd.service
    systemctl disable avahi-daemon.service
    systemctl disable kdump.service
    ;;
esac
