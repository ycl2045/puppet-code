class puppet::db(
	$mem_size = '128m',
	$pgsql = false, 
	$pg_host, 
	$pg_puppetdb_passwd) {

	package { 'puppetdb':
		ensure	=>	installed,
	}

	# puppetdb ssl-setup progress
	file {
		'/etc/puppetlabs/puppetdb/ssl/ca.pem':
			source	=>	'/etc/puppetlabs/puppet/ssl/certs/ca.pem',
			owner	=>	'puppetdb',
			group	=>	'puppetdb',
			mode	=>	'600';
		'/etc/puppetlabs/puppetdb/ssl/private.pem':
			source	=>	"/etc/puppetlabs/puppet/ssl/private_keys/${fqdn}.pem",
			owner	=>	'puppetdb',
			group	=>	'puppetdb',
			mode	=>	'600';
		'/etc/puppetlabs/puppetdb/ssl/public.pem':
			source	=>	"/etc/puppetlabs/puppet/ssl/certs/${fqdn}.pem",
			owner	=>	'puppetdb',
			group	=>	'puppetdb',
			mode	=>	'600';
		'/etc/puppetlabs/puppetdb/conf.d/jetty.ini':
			source	=>	'puppet:///modules/puppet/db/jetty.ini',
			owner	=>	'root',
			group	=>	'root',
			mode	=>	'644',
			notify	=>	Service['puppetdb'];
	}

	# postgresql
	if $pgsql == true {
		class { 'puppet::pgsql':
			pg_puppetdb_passwd	=>	$pg_puppetdb_passwd,
		}
	}

	# adjust puppetdb jvm xmx
	file { '/etc/sysconfig/puppetdb':
		content	=>	template('puppet/db/puppetdb.sysconfig.erb'),
		owner	=>	'root',
		group	=>	'root',
		mode	=>	'644',
	} ~>
	service { 'puppetdb':
		ensure	=>	running,
		enable	=>	true,
	}
}
