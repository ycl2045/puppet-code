#!/usr/bin/env bash

cat /etc/passwd |grep -v '^root' |grep '/sbin/nologin'|awk -F: 'BEGIN{user=""}{user=user$1","}END{print "nologinuser="user}'|sed -e 's/,$//g'|tr '[a-z]' '[A-Z]'

