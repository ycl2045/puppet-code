#!/usr/bin/env bash


# check rhosts file cannot be existed

[ -f /root/.rhosts ] &&  echo "rhost_file=yes"|tr '[a-z]' '[A-Z]' || echo "rhost_file=no"|tr '[a-z]' '[A-Z]'


# check  Security log must exist

[ -f /var/log/secure ] && echo "secure_file=yes" | tr '[a-z]' '[A-Z]'|| echo "secure_file=no"|tr '[a-z]' '[A-Z]'

# check etc authorization

ls -la /|awk '{if ( $NF == "etc" ) print "etc_authorization="$1}'|tr '[a-z]' '[A-Z]'

