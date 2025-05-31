### ALT Rsyslog-server
---
```
apt-get install rsyslog
```

`nano /etc/rsyslog.d/00-common.conf`:
```
module(load="imtcp")
input(type="imtcp" port="514")


global(
  parser.escapecontrolcharactertab="off"
)


$template FILENAME,"/var/log/vesr/%fromhost-ip%/syslog.log"
*.* ?FILENAME
```

```
systemctl restart rsyslog
```

### vESR
---
```
vesr(config)# syslog cli-commands
vesr(config)# syslog host altlinux
vesr(config-syslog-host)# remote-address 192.168.1.1
vesr(config-syslog-host)# transport tcp
vesr(config-syslog-host)# port 514
vesr(config-syslog-host)# severity warning
vesr(config-syslog-host)# end
vesr# commit
vesr# confirm
```

### Ecorouter
---
В `rsyslog.conf` global прописывать не нужно, только темплейт и отдельную папку, дальше одна команда:
```
rsyslog host 192.168.1.1
```
