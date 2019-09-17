#!/bin/bash
set -exu -o pipefail

# install cloud-init tools
yum -q -y install cloud-init cloud-utils cloud-utils-growpart

# let's randomise the root password
head -n1 /dev/urandom | md5sum | awk {'print $1'} | passwd --stdin root

# no password ssh root login allowed
sed -i -e 's/^PasswordAuthentication yes.*/PasswordAuthentication no/g' /etc/ssh/sshd_config

# grub config commandliee
sed -i -e 's/rhgb quiet/console=tty0 console=ttyS0,115200n8/g' /etc/default/grub
grub2-mkconfig -o /boot/grub2/grub.cfg

# For the instance to access the metadata service, you must disable the default zeroconf route:
echo "NOZEROCONF=yes" >> /etc/sysconfig/network

# let's clean it up a bit
rm -rf /etc/ssh/*key*
rm -f /etc/udev/rules.d/*-persistent-*
sed -i '/HWADDR/d' /etc/sysconfig/network-scripts/ifcfg-eth0
sed -i '/UUID/d' /etc/sysconfig/network-scripts/ifcfg-eth0
sed -i 's,UUID=[^[:blank:]]*,/dev/vda1,' /etc/fstab
sed -i 's,UUID=[^[:blank:]]*,/dev/vda1,' /boot/grub/grub.conf
rm -f /root/anaconda-ks.cfg
rm -f /root/install.log
rm -f /root/install.log.syslog
find /var/log -type f -delete
