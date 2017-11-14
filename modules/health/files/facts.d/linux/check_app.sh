#!/usr/bin/env bash


apache_home=`ps -ef|grep tomcat|grep -v grep|sed  -n 's/.*\(-Dcatalina.base=\)\(.*\)\(-Dcatalina.home\).*/\2/p'|head -1|sed s/[[:space:]]//g`

if [ -f ${apache_home}/conf/server.xml ];then
	cat ${apache_home}/conf/server.xml|egrep "<Connector port.*HTTP" |awk -F"\"" 'BEGIN{port=""}{port=$2","port}END{print "tomcat_port="port}'|sed 's/,$//g'
	cat ${apache_home}/conf/server.xml|grep bufferSize|sed 's/.*\(bufferSize=\)"\([0-9]*\).*/\1\2/g'
fi


if [ `ps -ef|grep nginx.conf|grep -v grep|wc -l` -ge 1 ];then
	echo "nginx_status=running"
else
	echo 'nginx_status=stopped'
fi

