#!/bin/bash
apt-get update
apt-get install vim telnet curl -y
/bin/sed  -i '33d' /etc/cloud/cloud.cfg
/bin/sed  -i '34d' /etc/cloud/cloud.cfg
/bin/sed  -i '35d' /etc/cloud/cloud.cfg
/bin/sed  -i '33d' /etc/cloud/cloud.cfg
echo 'data01' > /etc/hostname
/bin/hostname data01
cat /etc/hostname > /proc/sys/kernel/hostname
echo -e '127.0.0.1 localhost' > /etc/hosts
value=$(/usr/bin/curl http://169.254.169.254/latest/meta-data/local-ipv4)
echo $value data01.us8-test data01 >> /etc/hosts
mkdir /mnt/nfs
mkdir /mnt/backup
mkdir -p /data/database
mkdir /data/nfs
sleep 120
lsblk >> /root/disk-output.txt
mkswap /dev/xvdb
echo $(blkid -s UUID /dev/xvdb | sed -e 's/\"//g' | awk '{printf $2}') none swap sw 0 0 >> /etc/fstab
mkfs.ext4 /dev/xvdc
mkfs.ext4 /dev/xvdd
echo $(blkid -s UUID /dev/xvdc | sed -e 's/\"//g' | awk '{printf $2}') /data/database ext4 errors=remount-ro 0 1 >> /etc/fstab
echo $(blkid -s UUID /dev/xvdd | sed -e 's/\"//g' | awk '{printf $2}') /data/nfs ext4 errors=remount-ro 0 1 >> /etc/fstab
mount -a
swapon -a
apt-get install puppet facter lsb-release rsync git etckeeper -y
apt-get install postgresql-9.4 -y
echo -e 'host    all             all             all            md5' >> /etc/postgresql/9.4/main/pg_hba.conf
curl 'https://s3.amazonaws.com/aws-cli/awscli-bundle.zip' -o '/root/awscli-bundle.zip'
unzip /root/awscli-bundle.zip
cd /root
./awscli-bundle/install -i /usr/local/aws -b /usr/local/bin/aws
aws s3 cp s3://artemis-buckets/postgresql.conf /etc/postgresql/9.4/main/postgresql.conf
chown postgres:postgres /etc/postgresql/9.4/main/postgresql.conf
/etc/init.d/postgres restart
sudo -i -u postgres psql -c 'CREATE ROLE "group_ro";'
sudo -i -u postgres psql -c 'create role "sd";'
sudo -i -u postgres psql -c 'CREATE DATABASE "sg_us8-test";'
sudo -i -u postgres psql -c 'ALTER DATABASE "sg_us8-test" OWNER TO "sd";'
sudo -i -u postgres psql -c "ALTER USER sd WITH PASSWORD 'cQAm7v4B';"
sudo -i -u postgres psql -c 'ALTER ROLE sd LOGIN;'
sudo -i -u postgres psql -c 'alter role sd with CREATEROLE;'
sudo -i -u postgres psql -c "alter role sd with password 'cQAm7v4B';"
aws s3 cp s3://artemis-buckets/sg_us8-test.sql /var/lib/postgresql/sg_us8-test.sql
sudo -i -u postgres psql "sg_us8-test" -f sg_us8-test.sql
/etc/init.d/postgresql stop
mkdir /data/database/postgresql
mv /var/lib/postgresql/* /data/database/postgresql/
rm -rf /var/lib/postgresql
ln -s /data/database/postgresql /var/lib/postgresql
puppet agent --enable --test --server ccc.adm.servicegrid.cisco --tags=init,rsynchub,proxy,sdapt
puppet agent --test --server ccc.adm.servicegrid.cisco --tags=init,rsynchub,proxy,sdapt 2>&1 | tee -a /root/ccc.output.txt
/usr/sbin/usermod -u 1205 postgres
chown -R postgres:postgres /data/database/postgresql
chown -R postgres:postgres /var/lib/postgresql
chown -R postgres:postgres /var/log/postgresql
chown -R postgres:postgres /etc/postgresql
chown -R postgres:postgres /var/run/postgresql
/etc/init.d/postgresql start
/bin/rm -rf /etc/puppet/ssl
/bin/mv /var/lib/puppet/ssl /etc/puppet
sdpuppetrun
chown -R postgres:postgres /data/database/postgresql
chown -R postgres:postgres /var/lib/postgresql
chown -R postgres:postgres /var/log/postgresql
chown -R postgres:postgres /etc/postgresql
chown -R postgres:postgres /var/run/postgresql
/etc/init.d/postgresql restart
mount /mnt/nfs
mkdir /home/sd/converter
chown sd:sd /home/sd/converter
touch /mnt/nfs/isalive/P0 /mnt/nfs/isalive/P7 /mnt/nfs/isalive/P8 /mnt/nfs/isalive/group1 /mnt/nfs/isalive/group2 /mnt/nfs/isalive/group3 /mnt/nfs/isalive/P5 /mnt/nfs/isalive/P6 /mnt/nfs/isalive/group4
chown sd:sd /mnt/nfs/isalive/P0 /mnt/nfs/isalive/P7 /mnt/nfs/isalive/P8 /mnt/nfs/isalive/group1 /mnt/nfs/isalive/group2 /mnt/nfs/isalive/group3 /mnt/nfs/isalive/P5 /mnt/nfs/isalive/P6 /mnt/nfs/isalive/group4
apt-get purge openjdk-7-jre-headless:amd64 -y
apt-get purge openjdk-7-jre-headless -y
apt-get autoremove -y
aws s3 cp s3://artemis-buckets/artemis.service /run/systemd/generator.late/artemis.service
ln -s /run/systemd/generator.late/artemis.service /run/systemd/generator.late/runlevel2.target.wants
ln -s /run/systemd/generator.late/artemis.service /run/systemd/generator.late/runlevel3.target.wants
ln -s /run/systemd/generator.late/artemis.service /run/systemd/generator.late/runlevel4.target.wants
ln -s /run/systemd/generator.late/artemis.service /run/systemd/generator.late/runlevel5.target.wants
sdpuppetrun
/etc/init.d/postgresql restart
touch /var/run/sdcall_pid/P_super_group1.pid /var/run/sdcall_pid/P_super_group2.pid /var/run/sdcall_pid/P_super_group3.pid /var/run/sdcall_pid/P_super_group4.pid /var/run/sdcall_pid/ResponseMonitor.pid /var/run/sdcall_pid/UploadProcessor.pid /var/run/sdcall_pid/P0.pid /var/run/sdcall_pid/P7.pid /var/run/sdcall_pid/P8.pid
sdpuppetrun
sdpuppetrun 2>&1 | tee -a /root/puppet.output.txt
aptitude -y full-upgrade
update-initramfs -cut -k all
/bin/mount /mnt/backup
touch /mnt/backup/pg_dump/dump-$(date +"%Y-%m-%d").gz
chown postgres:postgres /mnt/backup/pg_dump/dump-$(date +"%Y-%m-%d").gz
echo -e '$PATH_TO_MAILQ   = "/usr/bin/mailq";' >> /usr/local/nagios/libexec/utils.pm
crontab -l | { cat; echo '@reboot /bin/mount /mnt/nfs'; } | crontab -
crontab -l | { cat; echo '@reboot /bin/mount /mnt/backup'; } | crontab -
crontab -l | { cat; echo '@reboot mount -o remount,rw  /sys/fs/cgroup'; } | crontab -
crontab -l | { cat; echo '@reboot /etc/init.d/ntp restart'; } | crontab -
crontab -l | { cat; echo '@reboot sleep 60; /etc/init.d/sd-all restart'; } | crontab -
reboot