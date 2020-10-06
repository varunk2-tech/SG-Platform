#!/bin/bash
apt-get update
apt-get install vim telnet curl -y
/bin/sed  -i '33d' /etc/cloud/cloud.cfg
/bin/sed  -i '34d' /etc/cloud/cloud.cfg
/bin/sed  -i '35d' /etc/cloud/cloud.cfg
/bin/sed  -i '33d' /etc/cloud/cloud.cfg
echo 'app01' > /etc/hostname
/bin/hostname app01
cat /etc/hostname > /proc/sys/kernel/hostname
echo -e '127.0.0.1 localhost' > /etc/hosts
value=$(/usr/bin/curl http://169.254.169.254/latest/meta-data/local-ipv4)
echo $value app01.us8-test app01 >> /etc/hosts
mkdir /mnt/nfs
apt-get install puppet facter lsb-release rsync git etckeeper -y
sleep 10
puppet agent --enable --test --server ccc.adm.servicegrid.cisco --tags=init,rsynchub,proxy,sdapt || echo done
puppet agent --test --server ccc.adm.servicegrid.cisco --tags=init,rsynchub,proxy,sdapt 2>&1 | tee -a /root/ccc.output.txt
sleep 2
/bin/rm -rf /etc/puppet/ssl/
/bin/mv /var/lib/puppet/ssl /etc/puppet
sleep 1200
sdpuppetrun 2>&1 | tee -a /root/puppet-output-txt
aptitude -y full-upgrade
update-initramfs -cut -k all
touch /var/run/sdcall_pid/HTTPBridge.pid /var/run/sdcall_pid/MailBridge.pid /var/run/sdcall_pid/FileBridge.pid
crontab -l | { cat; echo '@reboot /bin/mount /mnt/nfs'; } | crontab -
crontab -l | { cat; echo '@reboot mount -o remount,rw  /sys/fs/cgroup'; } | crontab -
crontab -l | { cat; echo '@reboot /etc/init.d/ntp restart'; } | crontab -
crontab -l | { cat; echo '@reboot sleep 60; /etc/init.d/sd-all restart'; } | crontab -
echo -e '$PATH_TO_MAILQ   = "/usr/bin/mailq";' >> /usr/local/nagios/libexec/utils.pm
apt-get purge openjdk-7-jre-headless:amd64 -y
apt-get purge openjdk-7-jre-headless -y
apt-get autoremove -y
lsblk >> /root/disk-output.txt
mkswap /dev/xvdb
sleep 2
echo $(blkid -s UUID /dev/xvdb | sed -e 's/\"//g' | awk '{printf $2}') none swap sw 0 0 >> /etc/fstab
mount -a
swapon -a
reboot