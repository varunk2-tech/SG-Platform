#!/bin/bash
apt-get update
apt-get install vim telnet curl -y
/bin/sed  -i '33d' /etc/cloud/cloud.cfg
/bin/sed  -i '34d' /etc/cloud/cloud.cfg
/bin/sed  -i '35d' /etc/cloud/cloud.cfg
/bin/sed  -i '33d' /etc/cloud/cloud.cfg
echo 'backup01' > /etc/hostname
/bin/hostname backup01
cat /etc/hostname > /proc/sys/kernel/hostname
echo -e '127.0.0.1 localhost' > /etc/hosts
value=$(/usr/bin/curl http://169.254.169.254/latest/meta-data/local-ipv4)
echo $value backup01.us8-test backup01 >> /etc/hosts
mkdir /mnt/nfs
mkdir -p /data/backup
sleep 100
mkfs.ext4 /dev/xvdc
sleep 3
echo $(blkid -s UUID /dev/xvdc | sed -e 's/\"//g' | awk '{printf $2}') /data/backup ext4 errors=remount-ro 0 1 >> /etc/fstab
mount -a
mount /data/backup
apt-get install puppet facter lsb-release rsync git etckeeper -y
sleep 10
puppet agent --enable --test --server ccc.adm.servicegrid.cisco --tags=init,rsynchub,proxy,sdapt || echo done
puppet agent --test --server ccc.adm.servicegrid.cisco --tags=init,rsynchub,proxy,sdapt 2>&1 | tee -a /root/ccc.output.txt
sleep 2
/bin/rm -rf /etc/puppet/ssl/
/bin/mv /var/lib/puppet/ssl /etc/puppet
sdpuppetrun 2>&1 | tee -a /root/puppet-output-txt
aptitude -y full-upgrade
update-initramfs -cut -k all
crontab -l | { cat; echo '@reboot /bin/mount /mnt/nfs'; } | crontab -
crontab -l | { cat; echo '@reboot mount -o remount,rw  /sys/fs/cgroup'; } | crontab -
crontab -l | { cat; echo '@reboot /etc/init.d/ntp restart'; } | crontab -
echo -e '$PATH_TO_MAILQ   = "/usr/bin/mailq";' >> /usr/local/nagios/libexec/utils.pm
lsblk >> /root/disk-output.txt
mkswap /dev/xvdb
sleep 2
echo $(blkid -s UUID /dev/xvdb | sed -e 's/\"//g' | awk '{printf $2}') none swap sw 0 0 >> /etc/fstab
mount -a
swapon -a
sleep 1800
reboot