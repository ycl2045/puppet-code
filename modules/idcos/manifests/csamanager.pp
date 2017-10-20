# == Class: idcos::csamanager
#
class idcos::csamanager {
  # resources
augeas { 'metadata_expire':
	context	=>	'/files/etc/yum.conf',
	changes	=>	'set main/metadata_expire 1m',
}
package { [
  'nginx',
	'redis',
	'tomcat',
	'hf-csa-web',
	'hf-csa-manager']:
	ensure	=>	latest;
}

exec { 'name':
	command => '/bin/echo',
	# path => '/usr/bin:/usr/sbin:/bin:/usr/local/bin',
	# refreshonly => true,
}


exec { '/usr/bin/unzip ROOT.war -d ROOT':
	cwd	=>	'/usr/yunji/hf-csa-manager/bin/',
	onlyif	=>	'test -f /usr/yunji/hf-csa-manager/bin/ROOT.war',
	creates	=>	'/usr/yunji/hf-csa-manager/bin/ROOT',
	path => '/usr/bin:/usr/sbin:/bin:/usr/local/bin',
}
ini_setting {
	default:
	ensure	=>	present,
		path	=>	'/usr/yunji/hf-csa-manager/bin/ROOT/WEB-INF/classes/application-default.properties',
		notify	=>	Service['tomcat'];
	'mysql':
	setting	=>	'spring.datasource.url',
	value	=>	'jdbc:mysql://55.3.15.146:3306/hf-csa?characterEncoding=UTF-8';
	'mysqlpass':
	setting	=>	'spring.datasource.password',
	value	=>	'P@ssw0rd';
	'redis':
	setting	=>	'spring.redis.host',
	value=>'55.3.15.149';
	'iaas':
	setting	=>	'iaas.connector.server.host',
	value	=>	'55.3.15.149';
	'cmdb':
	setting	=>	'sal.cmdb.service.url',
	value	=>	'http://55.3.15.150:18080';
	'cm':
		setting	=>	'sal.cm.service.url',
		value	=>	'http://55.3.15.147';
	'cli':
		setting	=>	'sal.cli.service.url',
		value	=>	'http://55.3.15.147:8081';
}

service { 'tomcat':
	ensure	=>	running,
}

# nginx

file {'/etc/nginx/conf.d/default.conf':
    content => template('idcos/csamanager/default.conf.erb'),
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
  }

service { 'nginx':
  ensure => running,
}

}
