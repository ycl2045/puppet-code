#!/usr/bin/env bash



# check vsftp 设置配置文件/etc/vsftpd/vsftpd.conf以下选项为：anonymous_enable=NO


[ -f /etc/vsftpd/vsftpd.conf ] && cat /etc/vsftpd/vsftpd.conf | egrep -v "^#|^$" |awk '{print $0}'|tr '[a-z]' '[A-Z]' || exit 0

