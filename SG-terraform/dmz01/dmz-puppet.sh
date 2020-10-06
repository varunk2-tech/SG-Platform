#!/bin/bash
apt-get update
apt-get install vim telnet curl -y
/bin/sed  -i '33d' /etc/cloud/cloud.cfg
/bin/sed  -i '34d' /etc/cloud/cloud.cfg
/bin/sed  -i '35d' /etc/cloud/cloud.cfg
/bin/sed  -i '33d' /etc/cloud/cloud.cfg
echo 'dmz01' > /etc/hostname
/bin/hostname dmz01
cat /etc/hostname > /proc/sys/kernel/hostname
echo -e '127.0.0.1 localhost' > /etc/hosts
value=$(/usr/bin/curl http://169.254.169.254/latest/meta-data/local-ipv4)
echo $value dmz01.us8-test dmz01 >> /etc/hosts
mkdir /mnt/nfs
apt-get install puppet facter lsb-release rsync git etckeeper -y
sleep 10
puppet agent --enable --test --server ccc.adm.servicegrid.cisco --tags=init,rsynchub,proxy,sdapt || echo done
puppet agent --test --server ccc.adm.servicegrid.cisco --tags=init,rsynchub,proxy,sdapt 2>&1 | tee -a /root/ccc.output.txt
/bin/rm -rf /etc/puppet/ssl/
/bin/mv /var/lib/puppet/ssl /etc/puppet
sleep 1200
sdpuppetrun 2>&1 | tee -a /root/puppet-output-txt
aptitude -y full-upgrade
update-initramfs -cut -k all
lsblk >> /root/disk-output.txt
mkswap /dev/xvdb
sleep 2
echo $(blkid -s UUID /dev/xvdb | sed -e 's/\"//g' | awk '{printf $2}') none swap sw 0 0 >> /etc/fstab
mount -a
swapon -a
crontab -l | { cat; echo '@reboot /bin/mount /mnt/nfs'; } | crontab -
crontab -l | { cat; echo '@reboot mount -o remount,rw  /sys/fs/cgroup'; } | crontab -
crontab -l | { cat; echo '@reboot /etc/init.d/ntp restart'; } | crontab -
echo -e '$PATH_TO_MAILQ   = "/usr/bin/mailq";' >> /usr/local/nagios/libexec/utils.pm
reboot
