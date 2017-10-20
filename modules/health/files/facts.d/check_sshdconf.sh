#!/usr/bin/env bash

#. SSH password cannot be empty

[ -f /etc/ssh/sshd_config ] && cat /etc/ssh/sshd_config |egrep -v "^#|^$"|awk '{if (NF == 2) print $1"="$2}'|tr '[a-z]' '[A-Z]'

