#!/bin/bash

apt-get install vsftpd anonftp -y

# Backups
cp /etc/xinetd.conf{,.bak}
cp /etc/vsftpd.conf{,.bak}

# New configs
echo "#
# Simple configuration file for xinetd
#
# Some defaults, and include /etc/xinetd.d/

defaults
{
        log_type = SYSLOG authpriv info
        log_on_success = PID HOST DURATION
        log_on_failure = HOST
        instances = 100
        per_source = 5
        only_from = 0.0.0.0
}

includedir /etc/xinetd.d
" > /etc/xinetd.conf

echo "# default: off
# description: The vsftpd FTP server.
service ftp
{
        disable = no
        socket_type     = stream
        protocol        = tcp
        wait            = no
        user            = root
        nice            = 10
        rlimit_as       = 200M
        server          = /usr/sbin/vsftpd
#       server_args     =
}
" > /etc/xinetd.d/vsftpd


echo "listen_ipv6=NO
anonymous_enable=NO
local_enable=YES
write_enable=YES
local_umask=066
dirmessage_enable=NO
use_localtime=YES
xferlog_enable=YES
connect_from_port_20=YES
#secure_chroot_dir=/var/run/vsftpd/empty
pam_service_name=vsftpd
rsa_cert_file=/etc/ssl/certs/ssl-cert-snakeoil.pem
rsa_private_key_file=/etc/ssl/private/ssl-cert-snakeoil.key
ssl_enable=NO

chroot_local_user=YES
allow_writeable_chroot=YES
pam_service_name=vsftpd
" > /etc/vsftpd.conf

service xinetd restart
systemctl enable xinetd
