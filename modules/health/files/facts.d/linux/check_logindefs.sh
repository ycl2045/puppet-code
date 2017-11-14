#!/usr/bin/env bash


[ -f /etc/login.defs ] && cat /etc/login.defs|egrep -v '^#|^$'|awk '{if (NF == 2) print $1"="$2}'|tr '[a-z]' '[A-Z]'

