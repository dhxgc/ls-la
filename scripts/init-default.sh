#!/bin/bash

# packets
apt-get install nano curl wget python3 openssh -y

# add our keys
cat /root/ls-la/ssh-keys/authorized_keys > /root/.ssh/authorized_keys

if [[ "$1" == "admin" ]]; then
    cp /root/ls-la/ssh-keys/$2/* /root/.ssh/
    chown 600 /root/.ssh/id_rsa
fi

# enable root
cp -r /etc/openssh/sshd_config{,.bak}
echo "PermitRootLogin yes
Subsystem       sftp    /usr/lib/openssh/sftp-server
AcceptEnv LANG LANGUAGE LC_ADDRESS LC_ALL LC_COLLATE LC_CTYPE
AcceptEnv LC_IDENTIFICATION LC_MEASUREMENT LC_MESSAGES LC_MONETARY
AcceptEnv LC_NAME LC_NUMERIC LC_PAPER LC_TELEPHONE LC_TIME
" > /etc/openssh/sshd_config

# enable sshd
systemctl --now enable sshd
systemctl restart sshd